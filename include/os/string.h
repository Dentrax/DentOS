/*
 * DentOS/include/DentOS.h:
 *
 * Header file for the implement string operations
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#ifndef DentOS_STRING_H
#define DentOS_STRING_H

#include "../stdint.h"

void *memset(void *ptr, uint8_t value, uint32_t num);
void *memsetw(void *ptr, uint16_t value, uint32_t num);

#endif
