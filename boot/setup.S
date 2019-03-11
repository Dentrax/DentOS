/*
 * DentOS/boot/setup.S:
 *
 * Low-level memory setup
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include <boot/boot.h>

.code16
.section .setup

#define CR0_PE 0x00000001      /* Protection Enable. */
#define CR0_EM 0x00000004      /* (Floating-point) Emulation. */
#define CR0_PG 0x80000000      /* Paging. */
#define CR0_WP 0x00010000      /* Write-Protect enable in kernel mode. */

.globl setup
setup:
	#GetMemSize (MAX 64MB)
	mov $(LOADER_KERN_BASE/0x10), %ax
	mov %ax, %ds
	mov %ax, %es

	movl $ram_map - LOADER_PHYS_BASE - KERNEL_BASE, %eax
	movl $100, %edx
	push $0x0

  #	https://stackoverflow.com/a/32639540/5685796
  #	https://stackoverflow.com/a/30507725/5685796
  # https://stackoverflow.com/a/33289761/5685796
	call detectMemory
	addr32 movl %eax, ram_size - LOADER_PHYS_BASE - KERNEL_BASE

	cli
	cld

1:
  inb $0x64, %al
	testb $0x2, %al
	jnz 1b

  movb $0xd1, %al
	outb %al, $0x64

1:
  inb $0x64, %al
	testb $0x2, %al
	jnz 1b

	movb $0xdf, %al
	outb %al, $0x60

1:
  inb $0x64, %al
	testb $0x2, %al
	jnz 1b

	addr32 lgdt gdtdesc - LOADER_PHYS_BASE - KERNEL_BASE

	movl %cr0, %eax
	orl $CR0_PE | CR0_WP | CR0_EM, %eax
	movl %eax, %cr0

	data32 ljmp $SEL_KCSEG, $load_edi_esi + LOADER_KERN_BASE - LOADER_PHYS_BASE - KERNEL_BASE

	.code32

load_edi_esi:
	mov $SEL_KDSEG, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss

	movl $LOADER_KERN_BASE, %esi
	movl $KERNEL_BASE, %edi

copy:
	movl $0x8000, %ecx	#32kB at a time
	rep
	movsw

	cmp $KERNEL_BASE, %esi
	jnz copy

	ljmp $SEL_KCSEG, $start

	.align 8
gdt:
	.quad 0x0000000000000000	# Null segment.  Not used by CPU.
	.quad 0x00cf9a000000ffff	# System code, base 0, limit 4 GB.
	.quad 0x00cf92000000ffff        # System data, base 0, limit 4 GB.

gdtdesc:
	.word	gdtdesc - gdt - 1	# Size of the GDT, minus 1 byte.
	.long	gdt	+ LOADER_KERN_BASE - LOADER_PHYS_BASE - KERNEL_BASE		# Address of the GDT.

.globl ram_map, ram_size
ram_size:
	.long 0x00
ram_map:
	.fill 2000/8,0x08, 0x00
