
DEVICE     = attiny2313
CLOCK      = 1000000
PROGRAMMER = -c avrispmkII -P usb
OBJECTS    = main.o
# Use http://www.engbedded.com/fusecalc
FUSES      = -U lfuse:w:0x54:m -U hfuse:w:0xdf:m -U efuse:w:0xff:m

ifeq ($(RELEASE),1)
COMPILE_OPT = -Os
else
COMPILE_OPT = -Os -g3 -gdwarf-2
endif

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE)
COMPILE = avr-gcc -Wl,--relax,--gc-sections -Wall $(COMPILE_OPT) -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -fdata-sections -ffunction-sections -ffreestanding -fno-schedule-insns2 -mcall-prologues -fno-tree-scev-cprop -fno-split-wide-types

# symbolic targets:
all:	main.hex

run:	all
	~/project/simavr/simavr/run_avr -g -mcu $(DEVICE) -freq $(CLOCK) main.hex &
	avr-gdb ; killall run_avr

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

.c.s:
	$(COMPILE) -S $< -o $@

flash:	clean all
	$(AVRDUDE) -U flash:w:main.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

# Xcode uses the Makefile targets "", "clean" and "install"
install: flash fuse

# if you use a bootloader, change the command below appropriately:
load: all
	bootloadHID main.hex

clean:
	rm -f main.hex main.elf $(OBJECTS)

# file targets:
main.elf: $(OBJECTS)
	$(COMPILE) -o main.elf $(OBJECTS) -lm

main.hex: main.elf
	rm -f main.hex
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	avr-size --format=avr --mcu=$(DEVICE) main.elf
# If you have an EEPROM section, you must also create a hex file for the
# EEPROM and add it to the "flash" target.

# Targets for code debugging and analysis:
disasm:	main.elf
	avr-objdump -d main.elf

cpp:
	$(COMPILE) -E main.c

