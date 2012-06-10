# makefile for Arduino core

PREFIX  = /usr/local

ROOT    = ./arduino-1.0.1
SRC     = $(ROOT)/hardware/arduino

MCU     = atmega328p
F_CPU   = 16000000L
CORE    = arduino
VARIANT = standard
USB_VID =
USB_PID =

VERSION = 100

# the lines below will most likely not require any changes

CC  = /usr/bin/avr-gcc
CXX = /usr/bin/avr-g++
AR  = /usr/bin/avr-ar
CP  = /usr/bin/install

MHZ = $(shell echo $(F_CPU) | sed -e 's/000000.*//')

INCDIR = $(PREFIX)/include/arduino
LIBDIR = $(PREFIX)/lib/arduino/$(MCU)/$(MHZ)/$(VARIANT)

SRC_H   = $(wildcard $(SRC)/cores/$(CORE)/*.h)  
SRC_C   = $(wildcard $(SRC)/cores/$(CORE)/*.c)  
SRC_CPP = $(wildcard $(SRC)/cores/$(CORE)/*.cpp)

OBJS = $(SRC_C:.c=.o) $(SRC_CPP:.cpp=.o)
LIB  = lib$(CORE).a

CFLAGS   = -g -Os -w -ffunction-sections -fdata-sections \
    -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -I$(SRC)/cores/$(CORE) \
    -DUSB_VID=$(USB_VID) -DUSB_PID=$(USB_PID) -I$(SRC)/variants/$(VARIANT)
CXXFLAGS = -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections  \
    -mmcu=$(MCU) -DF_CPU=$(F_CPU) -I$(SRC)/cores/$(CORE) \
    -DUSB_VID=$(USB_VID) -DUSB_PID=$(USB_PID) -I$(SRC)/variants/$(VARIANT)

all: $(LIB)

$(LIB): $(OBJS)
	$(AR) rcs $@ $?

install: $(LIB)
	$(CP) -D -C -m 644 $? $(LIBDIR)/$?
	$(CP) -d $(INCDIR)
	$(CP) -D -C -m 644 $(SRC_H) $(INCDIR)
	$(CP) -D -C -m 644 $(SRC)/variants/$(VARIANT)/pins_$(CORE).h $(INCDIR)/variants/$(VARIANT)/pins_$(CORE).h

install_wp: WProgram.h
	$(CP) -D -C -m 644 $? $(PREFIX)/include/arduino

install_mk: inc.mk
	$(CP) -D -C -m 644 $? $(PREFIX)/lib/arduino/$?

clean:
	$(RM) $(OBJS)
	$(RM) $(LIB)

uninstall:
	$(RM) -r $(PREFIX)/lib/arduino
	$(RM) -r $(INCDIR)
