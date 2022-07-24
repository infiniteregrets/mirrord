use std::{arch::asm, env, ffi::CStr, os::unix::io::RawFd};

use frida_gum::interceptor::Interceptor;
use libc::{c_char, c_int, sockaddr, socklen_t};
use mirrord_protocol::AddrInfoHint;
use tracing::{debug, error, trace};

use super::ops::*;
use crate::{
    error::LayerError,
    macros::{hook, hook_sym, try_hook},
    socket::AddrInfoHintExt,
};

unsafe extern "C" fn socket_detour(domain: c_int, type_: c_int, protocol: c_int) -> c_int {
    socket(domain, type_, protocol)
}

unsafe extern "C" fn bind_detour(
    sockfd: c_int,
    addr: *const sockaddr,
    addrlen: socklen_t,
) -> c_int {
    bind(sockfd, addr, addrlen)
}

unsafe extern "C" fn listen_detour(sockfd: RawFd, backlog: c_int) -> c_int {
    listen(sockfd, backlog)
}

unsafe extern "C" fn connect_detour(
    sockfd: RawFd,
    address: *const sockaddr,
    len: socklen_t,
) -> c_int {
    connect(sockfd, address, len)
}

unsafe extern "C" fn getpeername_detour(
    sockfd: RawFd,
    address: *mut sockaddr,
    address_len: *mut socklen_t,
) -> i32 {
    getpeername(sockfd, address, address_len)
}

unsafe extern "C" fn getsockname_detour(
    sockfd: RawFd,
    address: *mut sockaddr,
    address_len: *mut socklen_t,
) -> i32 {
    getsockname(sockfd, address, address_len)
}

unsafe extern "C" fn accept_detour(
    sockfd: c_int,
    address: *mut sockaddr,
    address_len: *mut socklen_t,
) -> i32 {
    let accept_fd = libc::accept(sockfd, address, address_len);

    if accept_fd == -1 {
        accept_fd
    } else {
        accept(sockfd, address, address_len, accept_fd)
    }
}

#[cfg(target_os = "linux")]
unsafe extern "C" fn accept4_detour(
    sockfd: i32,
    address: *mut sockaddr,
    address_len: *mut socklen_t,
    flags: i32,
) -> i32 {
    let accept_fd = libc::accept4(sockfd, address, address_len, flags);

    if accept_fd == -1 {
        accept_fd
    } else {
        accept(sockfd, address, address_len, accept_fd)
    }
}

#[cfg(all(target_arch = "aarch64", target_os = "macos"))]
/// We have a different version for macOS as a workaround for https://github.com/metalbear-co/mirrord/issues/184
unsafe extern "C" fn fcntl_detour(fd: c_int, cmd: c_int, mut arg: ...) -> c_int {
    let arg = arg.arg::<usize>();
    let fcntl_fd = libc::fcntl(fd, cmd, arg);
    fcntl(fd, cmd, fcntl_fd)
}

#[cfg(not(all(target_arch = "aarch64", target_os = "macos")))]
unsafe extern "C" fn fcntl_detour(fd: c_int, cmd: c_int, arg: ...) -> c_int {
    let fcntl_fd = libc::fcntl(fd, cmd, arg);
    fcntl(fd, cmd, fcntl_fd)
}

unsafe extern "C" fn dup_detour(fd: c_int) -> c_int {
    let dup_fd = libc::dup(fd);
    dup(fd, dup_fd)
}

unsafe extern "C" fn dup2_detour(oldfd: c_int, newfd: c_int) -> c_int {
    if oldfd == newfd {
        return newfd;
    }
    let dup2_fd = libc::dup2(oldfd, newfd);
    dup(oldfd, dup2_fd)
}

#[cfg(target_os = "linux")]
unsafe extern "C" fn dup3_detour(oldfd: c_int, newfd: c_int, flags: c_int) -> c_int {
    let dup3_fd = libc::dup3(oldfd, newfd, flags);
    dup(oldfd, dup3_fd)
}

/// Turns the raw pointer parameters into Rust types and calls `ops::getaddrinfo`.
///
/// # Warning:
/// - `raw_hostname`, `raw_servname`, and/or `raw_hints` might be null!
unsafe extern "C" fn getaddrinfo_detour(
    raw_node: *const c_char,
    raw_service: *const c_char,
    raw_hints: *const libc::addrinfo,
    out_addr_info: *mut *mut libc::addrinfo,
) -> c_int {
    trace!(
        "getaddrinfo_detour -> raw_node {:#?} | raw_service {:#?} | raw_hints {:#?} | out? {:#?}",
        raw_node,
        raw_service,
        *raw_hints,
        out_addr_info.is_null(),
    );

    let node = match (!raw_node.is_null())
        .then(|| CStr::from_ptr(raw_node).to_str())
        .transpose()
        .map_err(|fail| {
            error!("Failed converting raw_node from `c_char` with {:#?}", fail);

            libc::EAI_MEMORY
        }) {
        Ok(node) => node.map(String::from),
        Err(fail) => return fail,
    };

    let service = match (!raw_service.is_null())
        .then(|| CStr::from_ptr(raw_service).to_str())
        .transpose()
        .map_err(|fail| {
            error!(
                "Failed converting raw_service from `c_char` with {:#?}",
                fail
            );

            libc::EAI_MEMORY
        }) {
        Ok(service) => service.map(String::from),
        Err(fail) => return fail,
    };

    let hints = (!raw_hints.is_null()).then(|| AddrInfoHint::from_raw(*raw_hints));

    getaddrinfo(node, service, hints)
        .map(|c_addr_info_ptr| {
            out_addr_info.copy_from_nonoverlapping(&c_addr_info_ptr, 1);

            0
        })
        .map_err(|fail| {
            error!("Failed resolving DNS with {:#?}", fail);

            match fail {
                LayerError::IO(io_fail) => io_fail.raw_os_error().unwrap(),
                LayerError::DNSNoName => libc::EAI_NONAME,
                _ => libc::EAI_FAIL,
            }
        })
        .unwrap_or_else(|fail| fail)
}

/// Deallocates a `*mut libc::addrinfo` that was previously allocated with `Box::new` in
/// `getaddrinfo_detour` and converted into a raw pointer by `Box::into_raw`.
///
/// Also follows the `addr_info.ai_next` pointer, deallocating the next pointers in the linked list.
///
/// # Protocol
///
/// No need to send any sort of `free` message to `mirrord-agent`, as the `addrinfo` there is not
/// kept around.
///
/// # Warning
///
/// The `addrinfo` pointer has to be allocated respecting the `Box`'s
/// [memory layout](https://doc.rust-lang.org/std/boxed/index.html#memory-layout).
unsafe extern "C" fn freeaddrinfo_detour(addrinfo: *mut libc::addrinfo) {
    trace!("freeaddrinfo_detour -> addrinfo {:#?}", *addrinfo);

    // Iterate over `addrinfo` linked list dropping it.
    let mut current = addrinfo;
    while !current.is_null() {
        let current_box = Box::from_raw(current);

        current = (*current).ai_next;
        drop(current_box);
    }
}

// NOTE: golang calling convention
// func Syscall(trap int64, a1, a2, a3 uintptr) (r1, r2, err uintptr);
// Trap # in AX, args in DI SI DX R10 R8 R9, return in AX DX
// Note that this differs from "standard" ABI convention, which
// would pass 4th arg in CX, not R10.

// NOTE: how C calls socket() `gcc -S -masm intel -fverbose-asm -g -O2 test.c -o test.s`
/*
# test.c:18:     s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    .loc 1 18 9 view .LVU8
    mov	edx, DWORD PTR 12[rax]	# res.0_1->ai_protocol, res.0_1->ai_protocol
    mov	esi, DWORD PTR 8[rax]	# res.0_1->ai_socktype, res.0_1->ai_socktype
    mov	edi, DWORD PTR 4[rax]	# res.0_1->ai_family, res.0_1->ai_family
    call	socket@PLT	#
*/

// NOTE(July 23): arguments are passed in rdi, rsi, rdx, rcx, r8d, r9d...
/*
Example:
        mov     r9d, 3,
        mov     r8d, 2,
        movabs  rcx, 430,
        movabs  rdx, 3293,
        movabs  rsi, 29,
        movabs  rdi, 118,
*/

#[cfg(target_os = "linux")]
#[cfg(target_arch = "x86_64")]
#[naked]
unsafe extern "C" fn go_raw_syscall_detour() {
    asm!(
        "mov rsi, QWORD PTR [rsp+0x10]",
        "mov rdx, QWORD PTR [rsp+0x18]",
        "mov rcx, QWORD PTR [rsp+0x20]",
        "mov rdi, QWORD PTR [rsp+0x8]",
        "call c_abi_syscall_handler",
        // "mov  QWORD PTR [rsp+0x28],rax",
        // "mov  QWORD PTR [rsp+0x30],rdx",
        // "mov  QWORD PTR [rsp+0x38],0x0",
        "ret",
        options(noreturn),
    );
}

//TODO: Use variable arguments feature for params
//NOTE: The mapping for syscall constants is the same between Go ABI and C ABI.
//      Refer: https://cs.opensource.google/go/go/+/refs/tags/go1.18.4:src/syscall/zsysnum_linux_amd64.go;l=8
#[no_mangle]
unsafe extern "C" fn c_abi_syscall_handler(syscall: i64, param1: i64, param2: i64, param3: i64) {
    debug!("C ABI handler received `Syscall - {:?}` with args >> arg1 -> {:?}, arg2 -> {:?}, arg3 -> {:?}", syscall, param1, param2, param3);
    let mut res: i32 = match syscall {        
        libc::SYS_socket => {
            let sock = socket(param1 as i32, param2 as i32, param3 as i32);
            debug!("C ABI handler returned socket descriptor -> {:?}", sock);
            sock
        },
        _ => panic!("Unhandled Syscall - {:?}", syscall),
    };    
    asm!("mov rax, {res}",
         "mov rdx, 0",
        res = out(reg) res);
}

// NOTE: (July 20) - We need to figure if the binary being provided is compiled by go or not, for
// example if we end up hooking multiple symbols, it would be a waste to try_hook the symbol and log
// that it does not exist. Instead, check if the binary is compiled by go - skip the set of
// symbols/functions all together.

pub(crate) fn enable_socket_hooks(interceptor: &mut Interceptor, enabled_remote_dns: bool) {
    hook!(interceptor, "socket", socket_detour);
    hook!(interceptor, "bind", bind_detour);
    hook!(interceptor, "listen", listen_detour);
    hook!(interceptor, "connect", connect_detour);
    hook!(interceptor, "fcntl", fcntl_detour);
    hook!(interceptor, "dup", dup_detour);
    hook!(interceptor, "dup2", dup2_detour);
    try_hook!(interceptor, "getpeername", getpeername_detour);
    try_hook!(interceptor, "getsockname", getsockname_detour);
    #[cfg(target_os = "linux")]
    {
        try_hook!(interceptor, "uv__accept4", accept4_detour);
        try_hook!(interceptor, "accept4", accept4_detour);
        try_hook!(interceptor, "dup3", dup3_detour);
    }
    try_hook!(interceptor, "accept", accept_detour);

    if enabled_remote_dns {
        hook!(interceptor, "getaddrinfo", getaddrinfo_detour);
        hook!(interceptor, "freeaddrinfo", freeaddrinfo_detour);
    }

    // NOTE: Golang uses libc on macos
    // Golang hooks -
    hook_sym!(
        interceptor,
        "syscall.RawSyscall.abi0",
        go_raw_syscall_detour,
        "go-e2e"
    )
    // debug!("Hooking golang syscalls");
    // if cfg!(linux) {
    //     match env::var("MIRRORD_DEBUG_BINARY") {
    //         Ok(binary) => {
    //             debug!("binary: {}", binary);
    //             hook_sym!(interceptor, "RawSyscall", go_raw_syscall_detour, &binary)
    //         },
    //         Err(_) => error!("Failed to get MIRRORD_DEBUG_BINARY env var"),
    //     }
    // }
}
