# Makefile for building Arduino applications

PREFIX := /usr/local
PORT   := /dev/ttyUSB0

# change this if you wish to have an another board as the default board
BOARD  := atmega328

VERSION := 101

## the lines below will most likely not require any changes

DEPS    := $(DEPS)

# might be unset in older board definitions
VARIANT := standard

include $(PREFIX)/lib/arduino/boards/$(BOARD).inc

CC  := /usr/bin/avr-gcc
CXX := /usr/bin/avr-g++
LD  := /usr/bin/avr-gcc

OBJCOPY := /usr/bin/avr-objcopy
SIZE    := /usr/bin/avr-size
AVRDUDE := /usr/bin/avrdude

OBJS = $(shell echo $(SRCS) | sed -E 's/(\w+).[a-z]+/\1.o/g')

MHZ  = $(shell echo $(F_CPU) | sed -e 's/000000.*//')

INCDIR = $(PREFIX)/include/arduino
LIBDIR = $(PREFIX)/lib/arduino/$(MCU)/$(MHZ)/$(VARIANT)

DEP_H   = $(foreach var,$(DEPS),-I$(INCDIR)/$(var))
DEP_LIB = $(foreach var,$(DEPS),-l$(var))

DEFS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -DARDUINO=$(VERSION)
ifdef VID
  DEFS += -DUSB_VID=$(VID) -DUSB_PID=$(PID)
endif

CFLAGS = -g -Os -w -ffunction-sections -fdata-sections \
    $(DEFS) -I. -I$(INCDIR) -I$(INCDIR)/variants/$(VARIANT) $(DEP_H)
CXXFLAGS = -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections \
    $(DEFS) -I. -I$(INCDIR) -I$(INCDIR)/variants/$(VARIANT) $(DEP_H)

LDFLAGS  = -Os -Wl,--gc-sections -mmcu=$(MCU)

AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).hex
AVRDUDE_FLAGS = -V -F -C /etc/avrdude.conf -p $(MCU) -P $(PORT) -c $(PROTOCOL) \
    -b $(SPEED)

Q = @

hex: $(TARGET).hex
elf: $(TARGET).elf

$(TARGET).elf: $(OBJS)
	@echo "LD $(OBJS) -o $@"
	$(Q)$(LD) $(LDFLAGS) -o $@ $(OBJS) -L$(LIBDIR) $(DEP_LIB) -l$(CORE) -lm

upload: hex
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)

clean:
	$(Q)$(RM) $(TARGET).hex $(TARGET).elf $(OBJS)

.ino.o:
	@echo "CC -c $<"
	$(Q)$(CXX) $(CXXFLAGS) -x c++ -c -o $@ $<

.pde.o:
	@echo "CC -c $<"
	$(Q)$(CXX) $(CXXFLAGS) -x c++ -c -o $@ $<

.cpp.o:
	@echo "CC -c $<"
	$(Q)$(CXX) $(CXXFLAGS) -x c++ -c -o $@ $<

.c.o:
	@echo "CC -c $<"
	$(Q)$(CC) $(CFLAGS) -c -o $@ $<

.elf.hex:
	@echo "OBJCOPY $< $@"
	$(Q)$(OBJCOPY) -O ihex -R .eeprom $< $@
	@echo "SIZE $@"
	$(Q)$(SIZE) --target=ihex $@

.SUFFIXES: .ino .pde .elf .hex
