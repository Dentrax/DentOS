/*
 * DentOS/kernel/isr.c:
 *
 * Kernel memset functions
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include <os/string.h>

//Scan all the 'num' with 'pos' reference until 'ptr' pointer equals value
void *memset(void *ptr, uint8_t value, uint32_t num)
{
	unsigned char *pos = (unsigned char *)ptr;
	while(num--) *pos++ = value;
	return ptr;
}

//Scan all the 'num' with 'pos' reference until 'ptr' pointer equals value
void *memsetw(void *ptr, uint16_t value, uint32_t num)
{
	uint16_t *pos = (uint16_t *)ptr;
	while(num--) *pos++ = value;
	return ptr;
}
