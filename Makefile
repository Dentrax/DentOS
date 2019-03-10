VERSION = 1

GREEN   = \033[1;32m
WHITE   = \033[0;m

CC	= gcc -m32
LD = ld -melf_i386
OBJCOPY = objcopy

SRCDIR = .

DEFINES =
WARNINGS = -Wall -W -Wextra -Wstrict-prototypes -Wmissing-prototypes -Wsystem-headers
CFLAGS = -msoft-float -O -fno-stack-protector -fno-exceptions -fno-builtin -fno-pie -g -ffreestanding
CPPFLAGS = -nostdinc -I $(SRCDIR) -I $(SRCDIR)/lib/ -I $(SRCDIR)/include/
ASFLAGS = -Wa,--gstabs
LDFLAGS = -s -x -M --oformat binary
DEPS = -MMD -MF $(@:.o=.d)

SOURCES = $(shell find include kernel -name '*.c')
HEADERS = $(shell find include kernel -name '*.h')
OBJ = ${SOURCES:.c=.o}

OBJS  = boot/setup.o boot/start.o
OBJS += boot/setup_c.o
OBJS += init/main.o
OBJS += kernel/string.o kernel/io.o kernel/interrupt.o kernel/isr.o kernel/output.o

kernel.lds.s: CPPFLAGS += -P
kernel.lds.s: kernel.lds.S

all: os-image.bin

run: all
	qemu-system-x86_64 -fda os-image.bin

os-image.bin: boot.bin kernel.bin
	cat $^ > os-image.bin
	@printf "\n[$(GREEN)DONE$(WHITE)] DentOS\n"

boot/boot.o: boot/boot.S
	@printf "\n[$(GREEN)GCC$(WHITE)] boot/boot.o\n"
	$(CC) -c $< -o $@ $(ASFLAGS) $(CPPFLAGS) $(DEFINES)

boot.bin: boot/boot.o
	@printf "\n[$(GREEN)LD$(WHITE)] boot.bin > boot/boot.o\n"
	$(LD) -N -e 0 -Ttext 0x7c00 --oformat binary -o $@ $<

kernel.o: kernel.lds.s ${OBJS}
	@printf "\n[$(GREEN)LD$(WHITE)] kernel.bin > kernel.lds.s\n"
	$(LD) -T $< -o $@ $(OBJS)

kernel.bin: kernel.o
	@printf "\n[$(GREEN)CPY$(WHITE)] kernel.o > kernel.bin\n"
	$(OBJCOPY) -R .note -R .comment -S $< $@

.c.o:
	@printf "\n[$(GREEN).C.O$(WHITE)] GCC: $($@)\n"
	${CC} ${CFLAGS} ${CPPFLAGS} ${WARNINGS} ${DEFINES} ${DEPS} $ -c $< -o $@

.s.o:
	@printf "\n[$(GREEN).S.O$(WHITE)] GCC: $($@)\n"
	$(CC) -c $< -o $@ $(ASFLAGS) $(CPPFLAGS) $(DEFINES) $(DEPS)

clean:
	@printf "\n[$(GREEN)CLEAN$(WHITE)]\n"
	rm -rf *.o *.bin *.elf *.dis kernel.lds.s os-image.bin
	$(MAKE) -C boot -f Makefile clean;
	$(MAKE) -C kernel -f Makefile clean;
	$(MAKE) -C init -f Makefile clean;

c: clean
