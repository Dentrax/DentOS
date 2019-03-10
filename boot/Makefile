GREEN   = \033[1;32m
WHITE   = \033[0;m

CC	= gcc -m32

DEFINES =
CPPFLAGS = -nostdinc -I$(SRCDIR) -I$(SRCDIR)/lib -I$(SRCDIR)/include
ASFLAGS = -Wa,--gstabs

all: boot

boot.o: boot.S
	@printf "\n[$(GREEN)GCC$(WHITE)] BOOT: boot.o > boot.S\n"
	$(CC) -c $< -o $@ $(ASFLAGS) $(CPPFLAGS) $(DEFINES)

setup.o: setup.S
	@printf "\n[$(GREEN)GCC$(WHITE)] BOOT: setup.o > setup.S\n"
	$(CC) -c $< -o $@ $(ASFLAGS) $(CPPFLAGS) $(DEFINES)

start.o: start.S
	@printf "\n[$(GREEN)GCC$(WHITE)] BOOT: start.o > start.S\n"
	$(CC) -c $< -o $@ $(ASFLAGS) $(CPPFLAGS) $(DEFINES)

boot: boot.o setup.o start.o
	@printf "\n[$(GREEN)DONE$(WHITE)] BOOT: boot.o setup.o start.o\n"

clean:
	@printf "\n[$(GREEN)CLEAN$(WHITE)] BOOT\n"
	rm -rf *.o *.d *.bin *.dis *.elf
