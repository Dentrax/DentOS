/*
 * DentOS/kernel/isr.c:
 *
 * Kernel ISR's functions
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include "os/isr.h"

isr_t handlers[256];

void register_interrupt_handler(uint8_t index, isr_t handler){
  handlers[index] = handler;
}
