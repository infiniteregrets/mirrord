use core::ffi::CStr;
use std::{ffi::CString, io::SeekFrom, os::unix::io::RawFd, path::PathBuf};

use libc::{c_int, c_uint, AT_FDCWD, FILE, O_CREAT, O_RDONLY, S_IRUSR, S_IWUSR, S_IXUSR};
use mirrord_protocol::{
    CloseFileResponse, OpenFileResponse, OpenOptionsInternal, ReadFileResponse, SeekFileResponse,
    WriteFileResponse,
};
use tokio::sync::oneshot;
use tracing::error;

use super::*;
use crate::{
    common::blocking_send_hook_message,
    detour::{Bypass, Detour},
    error::{HookError, HookResult as Result},
    HookMessage, ENABLED_FILE_RO_OPS,
};

/// Helper function that retrieves the `remote_fd` (which is generated by our `IndexAllocator`).
#[tracing::instrument(level = "trace")]
fn get_remote_fd(local_fd: RawFd) -> Detour<usize> {
    Detour::Success(
        OPEN_FILES
            .lock()?
            .get(&local_fd)
            .cloned()
            // Bypass if we're not managing the relative part.
            .ok_or(Bypass::LocalFdNotFound(local_fd))?,
    )
}

/// The pair `shm_open`, `shm_unlink` are used to create a temporary file (in `/dev/shm/`), and then
/// remove it, as we only care about the `fd`. This is done to preserve `open_flags`, as
/// `memfd_create` will always return a `File` with read and write permissions.
#[tracing::instrument(level = "trace")]
unsafe fn create_local_fake_file(fake_local_file_name: CString, remote_fd: usize) -> Detour<RawFd> {
    let local_file_fd = unsafe {
        // `mode` is access rights: user, root, ...
        let local_file_fd = libc::shm_open(
            fake_local_file_name.as_ptr(),
            O_RDONLY | O_CREAT,
            (S_IRUSR | S_IWUSR | S_IXUSR) as c_uint,
        );

        libc::shm_unlink(fake_local_file_name.as_ptr());

        local_file_fd
    };

    // Close the remote file if the call to `libc::shm_open` failed and we have an invalid local fd.
    if local_file_fd == -1 {
        let _ = close_remote_file_on_failure(remote_fd)?;
        Detour::Error(HookError::LocalFileCreation(remote_fd))
    } else {
        Detour::Success(local_file_fd)
    }
}

#[tracing::instrument(level = "error")]
fn close_remote_file_on_failure(fd: usize) -> Result<CloseFileResponse> {
    // Close the remote file if the call to `libc::shm_open` failed and we have an invalid local fd.
    error!("Call to `libc::shm_open` resulted in an error, closing the file remotely!");

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    blocking_send_file_message(HookMessageFile::Close(Close {
        fd,
        file_channel_tx,
    }))?;

    file_channel_rx.blocking_recv()?.map_err(From::from)
}

fn blocking_send_file_message(message: HookMessageFile) -> Result<()> {
    blocking_send_hook_message(HookMessage::File(message))
}

fn path_from_rawish(rawish_path: Option<&CStr>) -> Detour<PathBuf> {
    let path = rawish_path
        .map(CStr::to_str)
        .transpose()
        .map_err(|fail| {
            warn!(
                "Failed converting `rawish_path` from `CStr` with {:#?}",
                fail
            );

            Bypass::CStrConversion
        })?
        .map(PathBuf::from)
        .ok_or(HookError::NullPointer)?;

    Detour::Success(path)
}

/// Blocking wrapper around `libc::open` call.
///
/// **Bypassed** when trying to load system files, and files from the current working directory
/// (which is different anyways when running in `-agent` context).
///
/// When called for a valid file, it blocks and sends an open file request to be handled by
/// `mirrord-agent`, and waits until it receives an open file response.
///
/// `open` is also used by other _open-ish_ functions, and it takes care of **creating** the _local_
/// and _remote_ file association, plus **inserting** it into the storage for `OPEN_FILES`.
#[tracing::instrument(level = "trace")]
pub(crate) fn open(rawish_path: Option<&CStr>, open_options: OpenOptionsInternal) -> Detour<RawFd> {
    let path = path_from_rawish(rawish_path)?;

    if IGNORE_FILES.is_match(path.to_str().unwrap_or_default()) {
        Detour::Bypass(Bypass::IgnoredFile(path.clone()))?
    } else if path.is_relative() {
        // Calls with non absolute paths are sent to libc::open.
        Detour::Bypass(Bypass::RelativePath(path.clone()))?
    };

    let read_only = ENABLED_FILE_RO_OPS
        .get()
        .expect("Should be set during initialization!");
    if *read_only && !open_options.is_read_only() {
        Detour::Bypass(Bypass::ReadOnly(path.clone()))?
    };

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let requesting_file = Open {
        path,
        open_options,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::Open(requesting_file))?;

    let OpenFileResponse { fd: remote_fd } = file_channel_rx.blocking_recv()??;

    // TODO: Need a way to say "open a directory", right now `is_dir` always returns false.
    // This requires having a fake directory name (`/fake`, for example), instead of just converting
    // the fd to a string.
    let fake_local_file_name = CString::new(remote_fd.to_string())?;
    let local_file_fd = unsafe { create_local_fake_file(fake_local_file_name, remote_fd) }?;

    OPEN_FILES.lock().unwrap().insert(local_file_fd, remote_fd);

    Detour::Success(local_file_fd)
}

/// Calls `open` and returns a `FILE` pointer based on the **local** `fd`.
#[tracing::instrument(level = "info")]
pub(crate) fn fopen(rawish_path: Option<&CStr>, rawish_mode: Option<&CStr>) -> Detour<*mut FILE> {
    let open_options: OpenOptionsInternal = rawish_mode
        .map(CStr::to_str)
        .transpose()
        .map_err(|fail| {
            warn!(
                "Failed converting `rawish_mode` from `CStr` with {:#?}",
                fail
            );

            Bypass::CStrConversion
        })?
        .map(String::from)
        .map(OpenOptionsInternalExt::from_mode)
        .unwrap_or_default();

    let local_file_fd = open(rawish_path, open_options)?;
    let result = OPEN_FILES
        .lock()?
        .get_key_value(&local_file_fd)
        .ok_or(Bypass::LocalFdNotFound(local_file_fd))
        // Convert the fd into a `*FILE`, this is be ok as long as `OPEN_FILES` holds the fd.
        .map(|(local_fd, _)| local_fd as *const _ as *mut _)?;

    Detour::Success(result)
}

#[tracing::instrument(level = "trace")]
pub(crate) fn fdopen(fd: RawFd, rawish_mode: Option<&CStr>) -> Detour<*mut FILE> {
    let _open_options: OpenOptionsInternal = rawish_mode
        .map(CStr::to_str)
        .transpose()
        .map_err(|fail| {
            warn!(
                "Failed converting `rawish_mode` from `CStr` with {:#?}",
                fail
            );

            Bypass::CStrConversion
        })?
        .map(String::from)
        .map(OpenOptionsInternalExt::from_mode)
        .unwrap_or_default();

    debug!("fdopen -> open_options {_open_options:#?}");

    // TODO: Check that the constraint: remote file must have the same mode stuff that is passed
    // here.
    let result = OPEN_FILES
        .lock()?
        .get_key_value(&fd)
        .ok_or(Bypass::LocalFdNotFound(fd))
        .inspect(|(local_fd, remote_fd)| debug!("fdopen -> {local_fd:#?} {remote_fd:#?}"))
        .map(|(local_fd, _)| local_fd as *const _ as *mut _)?;

    Detour::Success(result)
}

#[tracing::instrument(level = "trace")]
pub(crate) fn openat(
    fd: RawFd,
    rawish_path: Option<&CStr>,
    open_options: OpenOptionsInternal,
) -> Detour<RawFd> {
    let path = path_from_rawish(rawish_path)?;

    // `openat` behaves the same as `open` when the path is absolute. When called with AT_FDCWD, the
    // call is propagated to `open`.
    if path.is_absolute() || fd == AT_FDCWD {
        open(rawish_path, open_options)
    } else {
        // Relative path requires special handling, we must identify the relative part (relative to
        // what).
        let remote_fd = get_remote_fd(fd)?;

        let (file_channel_tx, file_channel_rx) = oneshot::channel();

        let requesting_file = OpenRelative {
            relative_fd: remote_fd,
            path,
            open_options,
            file_channel_tx,
        };

        blocking_send_file_message(HookMessageFile::OpenRelative(requesting_file))?;

        let OpenFileResponse { fd: remote_fd } = file_channel_rx.blocking_recv()??;
        let fake_local_file_name = CString::new(remote_fd.to_string())?;
        let local_file_fd = unsafe { create_local_fake_file(fake_local_file_name, remote_fd) }?;

        OPEN_FILES.lock()?.insert(local_file_fd, remote_fd);

        Detour::Success(local_file_fd)
    }
}

/// Blocking wrapper around `libc::read` call.
///
/// **Bypassed** when trying to load system files, and files from the current working directory, see
/// `open`.
#[tracing::instrument(level = "trace")]
pub(crate) fn read(local_fd: RawFd, read_amount: usize) -> Detour<ReadFileResponse> {
    // We're only interested in files that are paired with mirrord-agent.
    let remote_fd = get_remote_fd(local_fd)?;

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let reading_file = Read {
        remote_fd,
        buffer_size: read_amount,
        start_from: 0,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::Read(reading_file))?;

    Detour::Success(file_channel_rx.blocking_recv()??)
}

#[tracing::instrument(level = "trace")]
pub(crate) fn fgets(local_fd: RawFd, buffer_size: usize) -> Detour<ReadFileResponse> {
    // We're only interested in files that are paired with mirrord-agent.
    let remote_fd = get_remote_fd(local_fd)?;

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let reading_file = Read {
        remote_fd,
        buffer_size,
        start_from: 0,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::ReadLine(reading_file))?;

    Detour::Success(file_channel_rx.blocking_recv()??)
}

#[tracing::instrument(level = "trace")]
pub(crate) fn pread(local_fd: RawFd, buffer_size: usize, offset: u64) -> Detour<ReadFileResponse> {
    // We're only interested in files that are paired with mirrord-agent.
    let remote_fd = get_remote_fd(local_fd)?;

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let reading_file = Read {
        remote_fd,
        buffer_size,
        start_from: offset,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::ReadLimited(reading_file))?;

    Detour::Success(file_channel_rx.blocking_recv()??)
}

#[tracing::instrument(level = "trace")]
pub(crate) fn pwrite(local_fd: RawFd, buffer: &[u8], offset: u64) -> Detour<WriteFileResponse> {
    let remote_fd = get_remote_fd(local_fd)?;

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let writing_file = Write {
        remote_fd,
        write_bytes: buffer.to_vec(),
        start_from: offset,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::WriteLimited(writing_file))?;

    Detour::Success(file_channel_rx.blocking_recv()??)
}

#[tracing::instrument(level = "trace")]
pub(crate) fn lseek(local_fd: RawFd, offset: i64, whence: i32) -> Detour<u64> {
    let remote_fd = get_remote_fd(local_fd)?;

    let seek_from = match whence {
        libc::SEEK_SET => SeekFrom::Start(offset as u64),
        libc::SEEK_CUR => SeekFrom::Current(offset),
        libc::SEEK_END => SeekFrom::End(offset),
        invalid => {
            warn!(
                "lseek -> potential invalid value {:#?} for whence {:#?}",
                invalid, whence
            );
            return Detour::Bypass(Bypass::CStrConversion);
        }
    };

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let seeking_file = Seek {
        remote_fd,
        seek_from,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::Seek(seeking_file))?;

    let SeekFileResponse { result_offset } = file_channel_rx.blocking_recv()??;
    Detour::Success(result_offset)
}

#[tracing::instrument(level = "trace", skip(write_bytes))]
pub(crate) fn write(local_fd: RawFd, write_bytes: Option<Vec<u8>>) -> Detour<isize> {
    let remote_fd = get_remote_fd(local_fd)?;

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let writing_file = Write {
        remote_fd,
        write_bytes: write_bytes.ok_or(Bypass::EmptyBuffer)?,
        start_from: 0,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::Write(writing_file))?;

    let WriteFileResponse { written_amount } = file_channel_rx.blocking_recv()??;
    Detour::Success(written_amount.try_into()?)
}

#[tracing::instrument(level = "trace")]
pub(crate) fn close(fd: usize) -> Result<c_int> {
    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let closing_file = Close {
        fd,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::Close(closing_file))?;

    file_channel_rx.blocking_recv()??;
    Ok(0)
}

#[tracing::instrument(level = "trace")]
pub(crate) fn access(rawish_path: Option<&CStr>, mode: u8) -> Detour<c_int> {
    let path = path_from_rawish(rawish_path)?;

    if IGNORE_FILES.is_match(path.to_str().unwrap_or_default()) {
        Detour::Bypass(Bypass::IgnoredFile(path.clone()))?
    } else if path.is_relative() {
        // Calls with non absolute paths are sent to libc::open.
        Detour::Bypass(Bypass::RelativePath(path.clone()))?
    };

    let (file_channel_tx, file_channel_rx) = oneshot::channel();

    let access = Access {
        path,
        mode,
        file_channel_tx,
    };

    blocking_send_file_message(HookMessageFile::Access(access))?;

    file_channel_rx.blocking_recv()??;

    Detour::Success(0)
}
