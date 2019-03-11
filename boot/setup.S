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

  # Poll status register while busy.

1:
  inb $0x64, %al
	testb $0x2, %al
	jnz 1b

  # Send command for writing output port.

  movb $0xd1, %al
	outb %al, $0x64

  # Poll status register while busy.

1:
  inb $0x64, %al
	testb $0x2, %al
	jnz 1b

	# Enable A20 line.

	movb $0xdf, %al
	outb %al, $0x60

	# Poll status register while busy.

1:
  inb $0x64, %al
	testb $0x2, %al
	jnz 1b

	# Protected mode requires a GDT, so point the GDTR to our GDT.
	# We need a data32 prefix to ensure that all 32 bits of the GDT
	# descriptor are loaded (default is to load only 24 bits).
	# The CPU doesn't need an addr32 prefix but ELF doesn't do 16-bit
	# relocations.

	addr32 lgdt gdtdesc - LOADER_PHYS_BASE - KERNEL_BASE

	# Then we turn on the following bits in CR0:
	#    PE (Protect Enable): this turns on protected mode.
	#    PG (Paging): turns on paging.
	#    WP (Write Protect): if unset, ring 0 code ignores
	#       write-protect bits in page tables (!).
	#    EM (Emulation): forces floating-point instructions to trap.
	#       We don't support floating point.

	movl %cr0, %eax
	orl $CR0_PE | CR0_WP | CR0_EM, %eax
	movl %eax, %cr0

  # We're now in protected mode in a 16-bit segment.  The CPU still has
	# the real-mode code segment cached in %cs's segment descriptor.  We
	# need to reload %cs, and the easiest way is to use a far jump.
	# Because we're not running in a 32-bit segment the data32 prefix is
	# needed to jump to a 32-bit offset in the target segment.

	data32 ljmp $SEL_KCSEG, $1f + LOADER_KERN_BASE - LOADER_PHYS_BASE - KERNEL_BASE

	# We're now in protected mode in a 32-bit segment.
	# Let the assembler know.

	.code32

	# Reload all the other segment registers and the stack pointer to
	# point into our new GDT.

1:
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

  #### GDT

	.align 8
gdt:
	.quad 0x0000000000000000	# Null segment.  Not used by CPU.
	.quad 0x00cf9a000000ffff	# System code, base 0, limit 4 GB.
	.quad 0x00cf92000000ffff  # System data, base 0, limit 4 GB.

gdtdesc:
	.word	gdtdesc - gdt - 1	# Size of the GDT, minus 1 byte.
	.long	gdt	+ LOADER_KERN_BASE - LOADER_PHYS_BASE - KERNEL_BASE		# Address of the GDT.

	#### Physical memory size in 4 kB pages.  This is exported to the rest
	#### of the kernel.

.globl ram_map, ram_size
ram_size:
	.long 0x00
ram_map:
	.fill 2000/8,0x08, 0x00
