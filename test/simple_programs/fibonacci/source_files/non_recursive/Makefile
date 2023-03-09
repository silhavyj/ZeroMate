
ARMGNU ?= arm-none-eabi

AOPS = --warn --fatal-warnings
COPS = -Wall -Werror -O0 -nostdlib -nostartfiles -ffreestanding

all: kernel.elf

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.hex
	rm -f *.srec
	rm -f *.elf
	rm -f *.list
	rm -f *.img
	
main.o: main.c
	$(ARMGNU)-gcc $(COPS) -c main.c -o main.o

start.o: start.s
	$(ARMGNU)-as $(AOPS) start.s -o start.o

kernel.elf: link.ld start.o main.o
	$(ARMGNU)-ld start.o main.o -T link.ld -o kernel.elf
	$(ARMGNU)-objdump -D kernel.elf > kernel.list
