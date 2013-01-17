# makefile for Arduino core

ifndef PREFIX
  PREFIX := /usr/local
endif
ifndef ROOT
  ROOT := ./arduino-1.0.3
endif
ifndef VERSION
  VERSION := 103
endif

# change this if you wish to have an another board as the default board
BOARD := atmega328

## the lines below will most likely not require any changes

SRC := $(ROOT)/hardware/arduino
VARIANT := standard

include ./boards/$(BOARD).inc

MHZ := $(shell echo $(F_CPU) | sed -e 's/000000.*//')

CC  := /usr/bin/avr-gcc
CXX := /usr/bin/avr-g++
AR  := /usr/bin/avr-ar
CP  := /usr/bin/install
SED := /bin/sed

GCC_VERSION := $(shell $(CC) -dumpversion | cut -f1,2 -d. | tr -d '.')
GCC_VERSION_GE_47 := $(shell expr $(GCC_VERSION) \>= 47)

INCDIR = $(PREFIX)/include/arduino
LIBDIR = $(PREFIX)/lib/arduino/$(MCU)/$(MHZ)/$(VARIANT)

SRC_H   := $(wildcard $(SRC)/cores/$(CORE)/*.h)
SRC_C   := $(wildcard $(SRC)/cores/$(CORE)/*.c)
SRC_CPP := $(wildcard $(SRC)/cores/$(CORE)/*.cpp)

OBJS = $(SRC_C:.c=.o) $(SRC_CPP:.cpp=.o)
LIB  = lib$(CORE).a

DEFS = -mmcu=$(MCU) -DF_CPU=$(F_CPU)
ifdef VID
  DEFS += -DUSB_VID=$(VID) -DUSB_PID=$(PID)
endif

# enable backward compability flag with newer compilers
ifeq ($(GCC_VERSION_GE_47), 1)
  DEFS += -D__AVR_LIBC_DEPRECATED_ENABLE__
endif

CFLAGS = -g -Os -w -ffunction-sections -fdata-sections \
    $(DEFS) -I$(SRC)/cores/$(CORE) -I$(SRC)/variants/$(VARIANT)
CXXFLAGS = -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections \
    $(DEFS) -I$(SRC)/cores/$(CORE) -I$(SRC)/variants/$(VARIANT)

all: $(LIB)

$(LIB): $(OBJS)
	$(AR) rcs $@ $?

install: $(LIB)
	$(CP) -D -C -m 644 $? $(LIBDIR)/$?
	$(CP) -d $(INCDIR)
	$(CP) -D -C -m 644 $(SRC_H) $(INCDIR)
	$(CP) -D -C -m 644 $(SRC)/variants/$(VARIANT)/pins_$(CORE).h $(INCDIR)/variants/$(VARIANT)/pins_$(CORE).h
	$(CP) -D -C -m 644 ./boards/$(BOARD).inc $(PREFIX)/lib/arduino/boards/$(BOARD).inc

install_wp: WProgram.h
	$(CP) -D -C -m 644 $? $(PREFIX)/include/arduino

install_mk: inc.mk
	$(CP) -D -C -m 644 $? $(PREFIX)/lib/arduino/$?
	$(SED) -i "1iPREFIX=$(PREFIX)\nVERSION=$(VERSION)\n" $(PREFIX)/lib/arduino/$?

clean:
	$(RM) $(OBJS)
	$(RM) $(LIB)

uninstall:
	$(RM) -r $(PREFIX)/lib/arduino
	$(RM) -r $(INCDIR)
