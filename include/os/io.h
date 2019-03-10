/*
 * DentOS/include/DentOS.h:
 *
 * Header file for the implement assembly level IO operations
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#ifndef DentOS_IO_H
#define DentOS_IO_H

#include "../stdint.h"

//IO Access: https://wiki.osdev.org/Inline_Assembly/Examples

//FIXME: inline function not works, why?

//Sends a 8/16/32-bit value on a I/O location. Traditional names are outb, outw and outl respectively. The a modifier enforces val to be placed in the eax register before the asm command is issued and Nd allows for one-byte constant values to be assembled as constants, freeing the edx register for other cases.
void io_outb(uint16_t port, uint8_t value);

//Receives a 8/16/32-bit value from an I/O location. Traditional names are inb, inw and inl respectively.
uint8_t io_inb(uint16_t port);

//Forces the CPU to wait for an I/O operation to complete. only use this when there's nothing like a status register or an IRQ to tell you the info has been received.
inline void io_wait(void);

#endif
