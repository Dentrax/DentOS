GREEN   = \033[1;32m
WHITE   = \033[0;m

CFLAGS = -O2 -Wall -I../include -nostdlib -nostdinc -fno-builtin -fno-stack-protector

all: string.o port.o output.o

output.o: output.c
	@printf "\n[$(GREEN)GCC$(WHITE)] KERNEL: output.o > output.c\n"
	gcc $(CFLAGS) -c output.c

string.o: string.c
	@printf "\n[$(GREEN)GCC$(WHITE)] KERNEL: string.o > string.c\n"
	gcc $(CFLAGS) -c string.c

io.o: io.c
	@printf "\n[$(GREEN)GCC$(WHITE)] KERNEL: io.o > io.c\n"
	gcc $(CFLAGS) -c io.c

interrupt.o: interrupt.c
	@printf "\n[$(GREEN)GCC$(WHITE)] KERNEL: interrupt.o > interrupt.c\n"
	gcc $(CFLAGS) -c interrupt.c

isr.o: isr.c
	@printf "\n[$(GREEN)GCC$(WHITE)] KERNEL: isr.o > isr.c\n"
	gcc $(CFLAGS) -c isr.c

clean:
	@printf "\n[$(GREEN)CLEAN$(WHITE)] KERNEL\n"
	rm -rf *.o *.d *.bin *.dis *.elf
