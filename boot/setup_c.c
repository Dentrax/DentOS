/*
 * DentOS/boot/setup_c.c:
 *
 * Memory dedector
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

//https://wiki.osdev.org/Detecting_Memory_(x86)
__asm__(".code16gcc\n");
#include <stdint.h>

typedef struct SMAP_entry
{
	uint64_t Base; // base address QWORD
	uint64_t Length; // length QWORD
	uint32_t Type; // entry Ttpe
	uint32_t ACPI; // exteded
}__attribute__((packed)) SMAP_entry_t;

int __attribute__((noinline)) __attribute__((regparm(3))) detectMemory(SMAP_entry_t* buffer, int maxentries)
{
	uint32_t contID = 0;
	int entries = 0, signature, bytes;
	do
    {
      __asm__ __volatile__ ("int  $0x15"
                            : "=a"(signature), "=c"(bytes), "=b"(contID)
                            : "a"(0xE820), "b"(contID), "c"(24), "d"(0x534D4150), "D"(buffer));
      if (signature != 0x534D4150)
        return -1; // error
      if (bytes > 20 && (buffer->ACPI & 0x0001) == 0)
        {
          // ignore this entry
        }
      else
        {
          buffer++;
          entries++;
        }
    }
	while (contID != 0 && entries < maxentries);
	return entries;
}
