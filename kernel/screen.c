/*
 * DentOS/kernel/isr.c:
 *
 * Kernel screen cursor, color and print functions
 *
 * Copyright(C) 2019 Furkan Türkal
 *
 * This program comes with ABSOLUTELY NO WARRANTY; This is free software,
 * and you are welcome to redistribute it under certain conditions; See
 * file LICENSE, which is part of this source code package, for details.
 */

#include <os/screen.h>
#include <os/io.h>

uint16_t *screen = (uint16_t *)0xB8000;
uint16_t pointer = 0x0700;

int cursor_x = 0;
int cursor_y = 0;

void cursor_update()
{
	uint32_t index = (cursor_y * 80) + cursor_x;
	io_outb(VGA_CRTC_INDEX, 14);
	io_outb(VGA_CRTC_DATA,  (index >> 8));
	io_outb(VGA_CRTC_INDEX, 15);
	io_outb(VGA_CRTC_DATA,  (index & 0xFF));
}

void cursor_hide()
{
	io_outb(VGA_CRTC_INDEX, 10);
	io_outb(VGA_CRTC_DATA, (io_inb(VGA_CRTC_DATA) | 0x20));
}

void cursor_show()
{
	io_outb(VGA_CRTC_INDEX, 10);
	io_outb(VGA_CRTC_DATA, (io_inb(VGA_CRTC_DATA) & ~0x20));
}

void screen_clear()
{
  //Clean the screen
  memsetw(screen, (pointer | ' '), 80 * 25);

  //Set cursor positions to zero
  cursor_x = 0;
  cursor_y = 0;

  //Update cursor
  cursor_update();
}

void screen_set_color(char foreground, char background)
{
    pointer = ((background << 12) | ((foreground & 0x0F) << 8));
}

unsigned char putch(unsigned char ch)
{
	if(ch == 0) return 0;

  switch(ch)
	{
		case '\b':
			if(cursor_x > 0)
			{
				cursor_x--;
				cursor_update();
				putch(' ');
				cursor_x--;
			}
			break;
		case '\t':
			cursor_x = (cursor_x + 4) & ~(4 - 1);
			break;
		case '\r':
			cursor_x = 0;
			break;
		case '\n':
			cursor_x = 0;
			cursor_y++;
			break;
		default:
			if(ch >= ' ')
			{
				 *(screen + (cursor_y * 80) + cursor_x) = (pointer | ch);
				 cursor_x++;
			}
			break;
	}

  if(cursor_x >= 80)
	{
		cursor_x = 0;
		cursor_y++;
	}

  if(cursor_y >= 25)
	{
		cursor_y = 24;
		cursor_x = 0;

    int i;
    for(i = 0; i < 80 * 24; i++) {
      *(screen+i) = *(screen + i + 80);
    }

    memsetw(screen + 80 * 24, ' ', 80);
	}

  cursor_update();

  return ch;
}

void puts(char *text)
{
	while(*text) {
    putch(*text++);
  }
	putch('\n');
}

void putsnocr(char *text)
{
	while(*text){
		putch(*text++);
  }
}

void putdec(int x)
{
	if(x == 0)
	{
		putch('0');
		return;
	}

  int i = 0;
	char number[20];

  if(x < 0)
	{
		x = -x;
		putch('-');
	}

  while(x > 0){
		number[i++] = x % 10 + '0';
		x /= 10;
	}
	for(i--; i >= 0; i--){
		putch(number[i]);
  }
}

void puthex(int x)
{
	if(x == 0)
	{
		putch('0');
		return;
	}

	putsnocr("0x");

  int i = 0;
	char number[17];

  while(x > 0){
		number[i++] = (x % 16 < 10) ? x % 16 + '0' : x % 16 - 10 + 'A';
		x /= 16;
	}

	for(i--; i >= 0; i--){
		putch(number[i]);
  }
}

void printf(char *format, ...)
{
	va_list arg;
	va_start(arg, format);

  int n;
	char c;
	char *s;

	while(*format)
	{
		switch(*format)
		{
			case '%':
				format++;
				switch(*format)
				{
					case '%':
						putch(*format);
						break;
					case 'd':
						n = va_arg(arg,int);
						putdec(n);
						break;
					case 'x':
						n = va_arg(arg,int);
						puthex(n);
						break;
					case 'p':
						n = va_arg(arg,int);
						puthex(n);
						break;
					case 'c':
						c = (char)va_arg(arg,int);
						putch(c);
						break;
					case 's':
						s = va_arg(arg,char*);
						putsnocr(s);
						break;
				}
				break;
			default:
				putch(*format);
				break;
		}
		format++;
	}
	va_end(arg);
}
