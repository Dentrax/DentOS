/*
 * DentOS/include/DentOS.h:
 *
 * Header file for the implement IRQ's and ISR's
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#ifndef DentOS_ISR_H
#define DentOS_ISR_H

#include "../stdint.h"

//Interrupt Service Routines

#define IRQ0 32
#define IRQ1 33
#define IRQ2 34

typedef struct interrupt_frame
{
  uint32_t ds; //Data Segment
  uint32_t cs;
  uint32_t flags;
  uint32_t sp;
  uint32_t ss;
  uint32_t eax, ebx, ecx, edx;
} interrupt_frame;

typedef void (*isr_t)(interrupt_frame);

//http://clang.llvm.org/docs/AttributeReference.html#interrupt-avr
__attribute__ ((interrupt))
void interrupt_handler(isr_t handler);

void register_interrupt_handler(uint8_t index, isr_t handler);

#endif
