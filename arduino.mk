PREFIX  = /usr/local
VERSION = 22

PORT = /dev/ttyUSB0

MCU   = atmega328p
F_CPU = 16000000

PROGRAMMER  = stk500v1
UPLOAD_RATE = 57600

# the lines below will most likely not require any changes

INCLUDE = $(PREFIX)/include/arduino/
LIBDIR  = $(PREFIX)/lib

OBJS = $(SRCS:.pde=.o)

CC  = /usr/bin/avr-gcc
CXX = /usr/bin/avr-g++
LD  = /usr/bin/avr-gcc
RM  = rm -f

OBJCOPY  = /usr/bin/avr-objcopy
SIZE     = /usr/bin/avr-size
AVRDUDE  = /usr/bin/avrdude

MHZ = $(shell echo $(F_CPU) | sed -e 's/000000//')
LIB = arduino-$(MCU)_$(MHZ)

AFLAGS   = -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION)
CFLAGS   = -g -Os -w -ffunction-sections -fdata-sections $(AFLAGS) -I$(INCLUDE)
CXXFLAGS = -g -Os -w -x c++ -fno-exceptions -ffunction-sections -fdata-sections \
    $(AFLAGS) -I$(INCLUDE)
LDFLAGS  = -Os -lm -Wl,--gc-sections -mmcu=$(MCU)

FORMAT   = ihex

AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).hex
AVRDUDE_FLAGS = -V -F -C /etc/avrdude.conf -p $(MCU) -P $(PORT) -c $(PROGRAMMER) \
    -b $(UPLOAD_RATE)

hex: $(TARGET).hex
elf: $(TARGET).elf

$(TARGET).elf: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) -L$(LIBDIR) -l$(LIB)

upload: hex
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)

clean:
	$(RM) $(TARGET).hex $(TARGET).elf $(OBJS)

.pde.o:
	$(CXX) -c $(CXXFLAGS) $< -o $@

.elf.hex:
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@
	$(SIZE) --target=$(FORMAT) $@

.SUFFIXES: .pde .elf .hex
