/*
 * DentOS/boot/boot.S:
 *
 * Main boot loader
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include <boot/boot.h>

.code16 # Generate 16-bit code (we are using 16-bit mode)
.globl _start # Makes our label '_start' global. We can access it from outside

_start:
	xor	%ax, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %ss

  mov $STACK_POINTER, %esp

	call print
	.string "[bootloader] Initializing...\r\n"

	mov $(LOADER_KERN_BASE/0x10), %ax
	mov %ax, %es
	xor %bx, %bx

	call load_setup

  call load_efi

#	http://www.ctyme.com/intr/rb-0607.htm
#	https://stackoverflow.com/a/32705076/5685796
load_setup:
	pusha

	call print
	.string "[bootloader] Configurating boot sectors...\r\n"

	mov $0x0220, %ax	# AH->sr	AL->nrSec
	mov $0x0002, %cx	# CH->cyl	CL->sec
	mov $0x0000, %dh	# DH->head	DL->drive

	call print
	.string "[bootloader] Resetting hard drive...\r\n"

  # Reset hard drive
  int $0x13 # Call the function from interrupt 0x13
	or	%ah, %ah

  jz popa_ret

  call print
	.string "[bootloader] Loaded!\r\n"

hlt: # Stops executing
  jmp hlt

# Start address from EFI (offset 0x18)
load_efi:
	mov %es:0x18, %dx
	mov %dx, addr_bootable
	movw $(LOADER_KERN_BASE/0x10), addr_bootable+2

  call print
	.string "[bootloader] EFI address loaded\r\n"

  ljmp *addr_bootable

  ret

print:
	xchg %si, %ss:(%esp)
	push %ax

print_next_char:
	mov %cs:(%si), %al
	inc %si
	test %al, %al
	jz 1f
	call put_char
	jmp print_next_char
1:
  pop %ax
	xchg %si, %ss:(%esp)
	ret

put_char:
	pusha
	sub %bh, %bh
	mov $0x0e, %ah
	int $0x10

popa_ret:
	popa
	ret				# Error code still in CF

addr_bootable:
	.word 0x0000
	.word 0x0000

	.org LOADER_SIG - LOADER_BASE
	.word 0xaa55 # Tell the BIOS that is the bootable
