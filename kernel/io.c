/*
 * DentOS/kernel/io.c:
 *
 * Kernel IO functions
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include <os/io.h>

void io_outb(uint16_t port, uint8_t value)
{
  __asm__("outb %1, %0" : : "d"(port), "a" (value));
}

uint8_t io_inb(uint16_t port)
{
	unsigned char ret;
	__asm__("inb %1, %0" : "=a" (ret) : "d" (port));
	return ret;
}

inline void io_wait(void)
{
  //Port 0x80 is used for 'checkpoints' during POST
  asm volatile ( "outb %%al, $0x80" : : "a"(0) );
}
