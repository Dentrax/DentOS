/*
 * DentOS/kernel/interrupt.c:
 *
 * Kernel interrupt functions
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include <os/interrupt.h>

void interrupt_set()
{
	asm volatile ("sti");
}

void interrupt_clear()
{
	asm volatile("cli");
}

inline void interrupt_halt()
{
	asm volatile("hlt");
}

inline bool interrupts_enabled()
{
  unsigned long flags;
  asm volatile ("pushf\n\t"
                "pop %0"
                : "=g"(flags));
  return flags & (1 << 9);
}
