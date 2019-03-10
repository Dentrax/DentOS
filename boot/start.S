/*
 * DentOS/boot/setup_c.c:
 *
 * Main jumper
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include <boot/boot.h>

.section .start
.code32
.globl start
.extern main

start:
1:
  mov $SEL_KDSEG, %ax

  mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss

  addl $LOADER_PHYS_BASE, %esp
	movl $0, %ebp

	jmp main

1:
  jmp 1b
