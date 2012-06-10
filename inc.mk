PREFIX  = /usr/local
PORT    = /dev/ttyUSB0

DEPS    := $(DEPS)

MCU     = atmega328p
F_CPU   = 16000000
CORE    = arduino
VARIANT = standard
USB_VID =
USB_PID =

VERSION = 100

PROGRAMMER  = arduino
UPLOAD_RATE = 115200

# the lines below will most likely not require any changes

CC  = /usr/bin/avr-gcc
CXX = /usr/bin/avr-g++
LD  = /usr/bin/avr-gcc

OBJCOPY = /usr/bin/avr-objcopy
SIZE    = /usr/bin/avr-size
AVRDUDE = /usr/bin/avrdude

SRCS_INO = $(shell echo $(SRCS) | sed -e 's/\w*.pde//g')
SRCS_PDE = $(shell echo $(SRCS) | sed -e 's/\w*.ino//g')

OBJS = $(SRCS_INO:.ino=.o) $(SRCS_PDE:.pde=.o)

MHZ  = $(shell echo $(F_CPU) | sed -e 's/000000.*//')

INCDIR = $(PREFIX)/include/arduino
LIBDIR = $(PREFIX)/lib/arduino/$(MCU)/$(MHZ)/$(VARIANT)

DEP_H   = $(foreach var,$(DEPS),-I$(INCDIR)/$(var))
DEP_LIB = $(foreach var,$(DEPS),-l$(var))

CFLAGS   = -c -g -Os -w -ffunction-sections -fdata-sections \
    -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION)     \
    -DUSB_VID=$(USB_VID) -DUSB_PID=$(USB_PID) \
    -I$(INCDIR) -I$(INCDIR)/variants/$(VARIANT) $(DEP_H)
CXXFLAGS = -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections  \
    -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION)     \
    -DUSB_VID=$(USB_VID) -DUSB_PID=$(USB_PID) \
    -I$(INCDIR) -I$(INCDIR)/variants/$(VARIANT) $(DEP_H)

LDFLAGS  = -Os -Wl,--gc-sections -mmcu=$(MCU)

AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).hex
AVRDUDE_FLAGS = -V -F -C /etc/avrdude.conf -p $(MCU) -P $(PORT) -c $(PROGRAMMER) \
    -b $(UPLOAD_RATE)

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
	$(Q)$(CXX) $(CXXFLAGS) -x c++ -c $< -o $@

.pde.o:
	@echo "CC -c $<"
	$(Q)$(CXX) $(CXXFLAGS) -x c++ -c $< -o $@

.elf.hex:
	@echo "OBJCOPY $< $@"
	$(Q)$(OBJCOPY) -O ihex -R .eeprom $< $@
	@echo "SIZE $@"
	$(Q)$(SIZE) --target=ihex $@

.SUFFIXES: .ino .pde .elf .hex