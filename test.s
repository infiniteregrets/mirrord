	.file	"test.c"
	.intel_syntax noprefix
# GNU C17 (Ubuntu 9.4.0-1ubuntu1~20.04.1) version 9.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 9.4.0, GMP version 6.2.0, MPFR version 4.0.2, MPC version 1.1.0, isl version isl-0.22.1-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  -imultiarch x86_64-linux-gnu test.c -masm=intel
# -mtune=generic -march=x86-64 -auxbase-strip test.s -g -O2 -fverbose-asm
# -fasynchronous-unwind-tables -fstack-protector-strong -Wformat
# -Wformat-security -fstack-clash-protection -fcf-protection
# options enabled:  -fPIC -fPIE -faggressive-loop-optimizations
# -falign-functions -falign-jumps -falign-labels -falign-loops
# -fassume-phsa -fasynchronous-unwind-tables -fauto-inc-dec
# -fbranch-count-reg -fcaller-saves -fcode-hoisting
# -fcombine-stack-adjustments -fcommon -fcompare-elim -fcprop-registers
# -fcrossjumping -fcse-follow-jumps -fdefer-pop
# -fdelete-null-pointer-checks -fdevirtualize -fdevirtualize-speculatively
# -fdwarf2-cfi-asm -fearly-inlining -feliminate-unused-debug-types
# -fexpensive-optimizations -fforward-propagate -ffp-int-builtin-inexact
# -ffunction-cse -fgcse -fgcse-lm -fgnu-runtime -fgnu-unique
# -fguess-branch-probability -fhoist-adjacent-loads -fident -fif-conversion
# -fif-conversion2 -findirect-inlining -finline -finline-atomics
# -finline-functions-called-once -finline-small-functions -fipa-bit-cp
# -fipa-cp -fipa-icf -fipa-icf-functions -fipa-icf-variables -fipa-profile
# -fipa-pure-const -fipa-ra -fipa-reference -fipa-reference-addressable
# -fipa-sra -fipa-stack-alignment -fipa-vrp -fira-hoist-pressure
# -fira-share-save-slots -fira-share-spill-slots
# -fisolate-erroneous-paths-dereference -fivopts -fkeep-static-consts
# -fleading-underscore -flifetime-dse -flra-remat -flto-odr-type-merging
# -fmath-errno -fmerge-constants -fmerge-debug-strings
# -fmove-loop-invariants -fomit-frame-pointer -foptimize-sibling-calls
# -foptimize-strlen -fpartial-inlining -fpeephole -fpeephole2 -fplt
# -fprefetch-loop-arrays -free -freg-struct-return -freorder-blocks
# -freorder-blocks-and-partition -freorder-functions -frerun-cse-after-loop
# -fsched-critical-path-heuristic -fsched-dep-count-heuristic
# -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
# -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
# -fsched-stalled-insns-dep -fschedule-fusion -fschedule-insns2
# -fsemantic-interposition -fshow-column -fshrink-wrap
# -fshrink-wrap-separate -fsigned-zeros -fsplit-ivs-in-unroller
# -fsplit-wide-types -fssa-backprop -fssa-phiopt -fstack-clash-protection
# -fstack-protector-strong -fstdarg-opt -fstore-merging -fstrict-aliasing
# -fstrict-volatile-bitfields -fsync-libcalls -fthread-jumps
# -ftoplevel-reorder -ftrapping-math -ftree-bit-ccp -ftree-builtin-call-dce
# -ftree-ccp -ftree-ch -ftree-coalesce-vars -ftree-copy-prop -ftree-cselim
# -ftree-dce -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre
# -ftree-loop-if-convert -ftree-loop-im -ftree-loop-ivcanon
# -ftree-loop-optimize -ftree-parallelize-loops= -ftree-phiprop -ftree-pre
# -ftree-pta -ftree-reassoc -ftree-scev-cprop -ftree-sink -ftree-slsr
# -ftree-sra -ftree-switch-conversion -ftree-tail-merge -ftree-ter
# -ftree-vrp -funit-at-a-time -funwind-tables -fvar-tracking
# -fvar-tracking-assignments -fverbose-asm -fzero-initialized-in-bss
# -m128bit-long-double -m64 -m80387 -malign-stringops
# -mavx256-split-unaligned-load -mavx256-split-unaligned-store
# -mfancy-math-387 -mfp-ret-in-387 -mfxsr -mglibc -mieee-fp
# -mlong-double-80 -mmmx -mno-sse4 -mpush-args -mred-zone -msse -msse2
# -mstv -mtls-direct-seg-refs -mvzeroupper

	.text
.Ltext0:
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"http"
.LC1:
	.string	"www.example.com"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB9:
	.file 1 "test.c"
	.loc 1 5 12 view -0
	.cfi_startproc
	endbr64	
	sub	rsp, 88	#,
	.cfi_def_cfa_offset 96
# test.c:11:     getaddrinfo("www.example.com", "http", &hints, &res);
	.loc 1 11 5 is_stmt 0 view .LVU1
	lea	rsi, .LC0[rip]	#,
	lea	rdi, .LC1[rip]	#,
# test.c:5: int main() {
	.loc 1 5 12 view .LVU2
	mov	rax, QWORD PTR fs:40	# tmp95, MEM[(<address-space-1> long unsigned int *)40B]
	mov	QWORD PTR 72[rsp], rax	# D.2860, tmp95
	xor	eax, eax	# tmp95
	.loc 1 6 5 is_stmt 1 view .LVU3
	.loc 1 7 5 view .LVU4
	.loc 1 11 5 view .LVU5
	lea	rcx, 8[rsp]	# tmp88,
	lea	rdx, 16[rsp]	# tmp89,
	call	getaddrinfo@PLT	#
.LVL0:
	.loc 1 18 5 view .LVU6
# test.c:18:     s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
	.loc 1 18 53 is_stmt 0 view .LVU7
	mov	rax, QWORD PTR 8[rsp]	# res.0_1, res
# test.c:18:     s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
	.loc 1 18 9 view .LVU8
	mov	edx, DWORD PTR 12[rax]	# res.0_1->ai_protocol, res.0_1->ai_protocol
	mov	esi, DWORD PTR 8[rax]	# res.0_1->ai_socktype, res.0_1->ai_socktype
	mov	edi, DWORD PTR 4[rax]	# res.0_1->ai_family, res.0_1->ai_family
	call	socket@PLT	#
.LVL1:
# test.c:20: }
	.loc 1 20 1 view .LVU9
	mov	rax, QWORD PTR 72[rsp]	# tmp96, D.2860
	xor	rax, QWORD PTR fs:40	# tmp96, MEM[(<address-space-1> long unsigned int *)40B]
	jne	.L5	#,
	xor	eax, eax	#
	add	rsp, 88	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret	
.L5:
	.cfi_restore_state
	call	__stack_chk_fail@PLT	#
.LVL2:
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.text
.Letext0:
	.file 2 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/socket.h"
	.file 4 "/usr/include/x86_64-linux-gnu/bits/sockaddr.h"
	.file 5 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h"
	.file 6 "/usr/include/netinet/in.h"
	.file 7 "/usr/include/netdb.h"
	.file 8 "/usr/include/x86_64-linux-gnu/sys/socket.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x301
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF41
	.byte	0xc
	.long	.LASF42
	.long	.LASF43
	.long	.Ldebug_ranges0+0
	.quad	0
	.long	.Ldebug_line0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF0
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF1
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF2
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF3
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF4
	.uleb128 0x3
	.long	.LASF6
	.byte	0x2
	.byte	0x26
	.byte	0x17
	.long	0x29
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF5
	.uleb128 0x3
	.long	.LASF7
	.byte	0x2
	.byte	0x28
	.byte	0x1c
	.long	0x30
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.long	.LASF8
	.byte	0x2
	.byte	0x2a
	.byte	0x16
	.long	0x37
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF9
	.uleb128 0x5
	.byte	0x8
	.long	0x8b
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF10
	.uleb128 0x3
	.long	.LASF11
	.byte	0x2
	.byte	0xd1
	.byte	0x17
	.long	0x37
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF12
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF13
	.uleb128 0x3
	.long	.LASF14
	.byte	0x3
	.byte	0x21
	.byte	0x15
	.long	0x92
	.uleb128 0x3
	.long	.LASF15
	.byte	0x4
	.byte	0x1c
	.byte	0x1c
	.long	0x30
	.uleb128 0x6
	.long	.LASF24
	.byte	0x10
	.byte	0x3
	.byte	0xb2
	.byte	0x8
	.long	0xec
	.uleb128 0x7
	.long	.LASF16
	.byte	0x3
	.byte	0xb4
	.byte	0x5
	.long	0xb8
	.byte	0
	.uleb128 0x7
	.long	.LASF17
	.byte	0x3
	.byte	0xb5
	.byte	0xa
	.long	0xec
	.byte	0x2
	.byte	0
	.uleb128 0x8
	.long	0x8b
	.long	0xfc
	.uleb128 0x9
	.long	0x3e
	.byte	0xd
	.byte	0
	.uleb128 0x3
	.long	.LASF18
	.byte	0x5
	.byte	0x18
	.byte	0x13
	.long	0x4c
	.uleb128 0x3
	.long	.LASF19
	.byte	0x5
	.byte	0x19
	.byte	0x14
	.long	0x5f
	.uleb128 0x3
	.long	.LASF20
	.byte	0x5
	.byte	0x1a
	.byte	0x14
	.long	0x72
	.uleb128 0xa
	.byte	0x10
	.byte	0x6
	.byte	0xd6
	.byte	0x5
	.long	0x14e
	.uleb128 0xb
	.long	.LASF21
	.byte	0x6
	.byte	0xd8
	.byte	0xa
	.long	0x14e
	.uleb128 0xb
	.long	.LASF22
	.byte	0x6
	.byte	0xd9
	.byte	0xb
	.long	0x15e
	.uleb128 0xb
	.long	.LASF23
	.byte	0x6
	.byte	0xda
	.byte	0xb
	.long	0x16e
	.byte	0
	.uleb128 0x8
	.long	0xfc
	.long	0x15e
	.uleb128 0x9
	.long	0x3e
	.byte	0xf
	.byte	0
	.uleb128 0x8
	.long	0x108
	.long	0x16e
	.uleb128 0x9
	.long	0x3e
	.byte	0x7
	.byte	0
	.uleb128 0x8
	.long	0x114
	.long	0x17e
	.uleb128 0x9
	.long	0x3e
	.byte	0x3
	.byte	0
	.uleb128 0x6
	.long	.LASF25
	.byte	0x10
	.byte	0x6
	.byte	0xd4
	.byte	0x8
	.long	0x199
	.uleb128 0x7
	.long	.LASF26
	.byte	0x6
	.byte	0xdb
	.byte	0x9
	.long	0x120
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	0x17e
	.uleb128 0xd
	.long	.LASF27
	.byte	0x6
	.byte	0xe4
	.byte	0x1e
	.long	0x199
	.uleb128 0xd
	.long	.LASF28
	.byte	0x6
	.byte	0xe5
	.byte	0x1e
	.long	0x199
	.uleb128 0xe
	.long	.LASF29
	.byte	0x30
	.byte	0x7
	.value	0x235
	.byte	0x8
	.long	0x235
	.uleb128 0xf
	.long	.LASF30
	.byte	0x7
	.value	0x237
	.byte	0x7
	.long	0x6b
	.byte	0
	.uleb128 0xf
	.long	.LASF31
	.byte	0x7
	.value	0x238
	.byte	0x7
	.long	0x6b
	.byte	0x4
	.uleb128 0xf
	.long	.LASF32
	.byte	0x7
	.value	0x239
	.byte	0x7
	.long	0x6b
	.byte	0x8
	.uleb128 0xf
	.long	.LASF33
	.byte	0x7
	.value	0x23a
	.byte	0x7
	.long	0x6b
	.byte	0xc
	.uleb128 0xf
	.long	.LASF34
	.byte	0x7
	.value	0x23b
	.byte	0xd
	.long	0xac
	.byte	0x10
	.uleb128 0xf
	.long	.LASF35
	.byte	0x7
	.value	0x23c
	.byte	0x14
	.long	0x235
	.byte	0x18
	.uleb128 0xf
	.long	.LASF36
	.byte	0x7
	.value	0x23d
	.byte	0x9
	.long	0x85
	.byte	0x20
	.uleb128 0xf
	.long	.LASF37
	.byte	0x7
	.value	0x23e
	.byte	0x14
	.long	0x23b
	.byte	0x28
	.byte	0
	.uleb128 0x5
	.byte	0x8
	.long	0xc4
	.uleb128 0x5
	.byte	0x8
	.long	0x1b6
	.uleb128 0x10
	.long	.LASF44
	.byte	0x1
	.byte	0x5
	.byte	0x5
	.long	0x6b
	.quad	.LFB9
	.quad	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x2e2
	.uleb128 0x11
	.string	"s"
	.byte	0x1
	.byte	0x6
	.byte	0x9
	.long	0x6b
	.uleb128 0x12
	.long	.LASF38
	.byte	0x1
	.byte	0x7
	.byte	0x15
	.long	0x1b6
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x13
	.string	"res"
	.byte	0x1
	.byte	0x7
	.byte	0x1d
	.long	0x23b
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.uleb128 0x14
	.quad	.LVL0
	.long	0x2e2
	.long	0x2c7
	.uleb128 0x15
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC1
	.uleb128 0x15
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x9
	.byte	0x3
	.quad	.LC0
	.uleb128 0x15
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x15
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.byte	0
	.uleb128 0x16
	.quad	.LVL1
	.long	0x2ef
	.uleb128 0x16
	.quad	.LVL2
	.long	0x2fb
	.byte	0
	.uleb128 0x17
	.long	.LASF39
	.long	.LASF39
	.byte	0x7
	.value	0x294
	.byte	0xc
	.uleb128 0x18
	.long	.LASF40
	.long	.LASF40
	.byte	0x8
	.byte	0x66
	.byte	0xc
	.uleb128 0x19
	.long	.LASF45
	.long	.LASF45
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x17
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x2111
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x4109
	.byte	0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.LFB9
	.quad	.LFE9-.LFB9
	.quad	0
	.quad	0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.LFB9
	.quad	.LFE9
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF35:
	.string	"ai_addr"
.LASF6:
	.string	"__uint8_t"
.LASF33:
	.string	"ai_protocol"
.LASF34:
	.string	"ai_addrlen"
.LASF42:
	.string	"test.c"
.LASF43:
	.string	"/home/mehula/mirrord"
.LASF41:
	.string	"GNU C17 9.4.0 -masm=intel -mtune=generic -march=x86-64 -g -O2 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF30:
	.string	"ai_flags"
.LASF21:
	.string	"__u6_addr8"
.LASF27:
	.string	"in6addr_any"
.LASF31:
	.string	"ai_family"
.LASF4:
	.string	"signed char"
.LASF26:
	.string	"__in6_u"
.LASF22:
	.string	"__u6_addr16"
.LASF1:
	.string	"short unsigned int"
.LASF23:
	.string	"__u6_addr32"
.LASF39:
	.string	"getaddrinfo"
.LASF8:
	.string	"__uint32_t"
.LASF45:
	.string	"__stack_chk_fail"
.LASF15:
	.string	"sa_family_t"
.LASF0:
	.string	"unsigned char"
.LASF7:
	.string	"__uint16_t"
.LASF3:
	.string	"long unsigned int"
.LASF28:
	.string	"in6addr_loopback"
.LASF32:
	.string	"ai_socktype"
.LASF29:
	.string	"addrinfo"
.LASF36:
	.string	"ai_canonname"
.LASF2:
	.string	"unsigned int"
.LASF12:
	.string	"long long unsigned int"
.LASF18:
	.string	"uint8_t"
.LASF44:
	.string	"main"
.LASF37:
	.string	"ai_next"
.LASF11:
	.string	"__socklen_t"
.LASF13:
	.string	"long long int"
.LASF16:
	.string	"sa_family"
.LASF10:
	.string	"char"
.LASF38:
	.string	"hints"
.LASF5:
	.string	"short int"
.LASF19:
	.string	"uint16_t"
.LASF40:
	.string	"socket"
.LASF20:
	.string	"uint32_t"
.LASF9:
	.string	"long int"
.LASF14:
	.string	"socklen_t"
.LASF17:
	.string	"sa_data"
.LASF24:
	.string	"sockaddr"
.LASF25:
	.string	"in6_addr"
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
