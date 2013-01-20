# Makefile for building Arduino applications

ifndef PREFIX
  PREFIX := /usr/local
endif
ifndef PORT
  PORT := /dev/ttyUSB0
endif
ifndef VERSION
  VERSION := 103
endif

# change this if you wish to have an another board as the default board
ifndef BOARD
  BOARD := atmega328
endif

## the lines below will most likely not require any changes

DEPS := $(DEPS)

VARIANT := standard

include $(PREFIX)/lib/arduino/boards/$(BOARD).inc

MHZ  := $(shell echo $(F_CPU) | sed -e 's/000000.*//')

CC  := /usr/bin/avr-gcc
CXX := /usr/bin/avr-g++
LD  := /usr/bin/avr-gcc

GCC_VERSION := $(shell $(CC) -dumpversion | cut -f1,2 -d. | tr -d '.')
GCC_VERSION_GE_47 := $(shell expr $(GCC_VERSION) \>= 47)

OBJCOPY := /usr/bin/avr-objcopy
SIZE    := /usr/bin/avr-size
AVRDUDE := /usr/bin/avrdude

OBJS := $(shell echo $(SRCS) | sed -E 's/(\w+).[a-z]+/\1.o/g')

INCDIR = $(PREFIX)/include/arduino
LIBDIR = $(PREFIX)/lib/arduino/$(MCU)/$(MHZ)/$(VARIANT)

DEP_H   := $(foreach var,$(DEPS),-I$(INCDIR)/$(var))
DEP_LIB := $(foreach var,$(DEPS),-l$(var))

DEFS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -DARDUINO=$(VERSION)
ifdef VID
  DEFS += -DUSB_VID=$(VID) -DUSB_PID=$(PID)
endif

# enable backward compability flag with newer compilers
ifeq ($(GCC_VERSION_GE_47), 1)
  DEFS += -D__AVR_LIBC_DEPRECATED_ENABLE__
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

print_boards:
	@for i in $(PREFIX)/lib/arduino/boards/*.inc; do b=$$(basename $$i .inc); n=$$(head -1 $$i | sed -e 's/^# //'); echo "$$b|$$n"; done | column -s '|' -t

print_libraries print_libs:
	@for i in $$(find $(PREFIX)/include/arduino/ -mindepth 1 -maxdepth 1 -type d | grep -v variants); do b=$$(basename $$i); echo $$b; done
