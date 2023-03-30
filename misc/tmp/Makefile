
ARMGNU ?= arm-none-eabi

AOPS = --warn --fatal-warnings
COPS = -Wall -Werror -O2 -nostdlib -nostartfiles -ffreestanding

all: kernel.img

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.hex
	rm -f *.srec
	rm -f *.img

start.o: start.s
	$(ARMGNU)-as $(AOPS) start.s -o start.o

blinker.o: blinker.c
	$(ARMGNU)-gcc $(COPS) -c blinker.c -o blinker.o

blinker.elf: link.ld start.o blinker.o
	$(ARMGNU)-ld start.o blinker.o -T link.ld -o blinker.elf
	$(ARMGNU)-objdump -D blinker.elf > blinker.list

kernel.img: blinker.elf
	$(ARMGNU)-objcopy --srec-forceS3 blinker.elf -O srec blinker.srec
	$(ARMGNU)-objcopy blinker.elf -O binary kernel.img
