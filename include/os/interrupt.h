/*
 * DentOS/include/DentOS.h:
 *
 * Header file for the implement assembly level interrupts
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#ifndef DentOS_INTERRUPT_H
#define DentOS_INTERRUPT_H

#include "../stdint.h"

// Interrupts
//TODO: Fix the compiler error when the function marked as 'inline'
void interrupt_set();
void interrupt_clear();
inline void interrupt_halt();
inline bool interrupts_enabled();

#endif
