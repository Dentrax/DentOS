/*
 * DentOS/init/main.c:
 *
 * Kernel main()
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include <stdint.h>
#include <os/screen.h>
#include <os/interrupt.h>

int main()
{

  //interrupt_clear();

  //screen_clear();

  printf("\r");

  printf("[KERNEL]: Initializing...\t");

  printf("\n");

  screen_set_color(COLOR_RED, COLOR_GREEN);

  printf("Welcome to DentOS!\t");

  //interrupt_set();

	for(;;);
}
