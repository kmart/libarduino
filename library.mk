# makefile for Arduino standard libraries

ifndef PREFIX
  PREFIX := /usr/local
endif
ifndef ROOT
  $(error ROOT is undefined)
endif
ifndef REVISION
  REVISION := $(shell cat $(PREFIX)/lib/arduino/REVISION)
endif

# directory containing the library source
ifndef SRC
  SRC := $(ROOT)/libraries/$(NAME)
endif

# change this if you wish to have an another board as the default board
ifndef BOARD
  BOARD := atmega328
endif

## the lines below will most likely not require any changes

NAME :=
DEPS :=

VARIANT := standard

include $(PREFIX)/lib/arduino/boards/$(BOARD).inc

MHZ := $(shell echo $(F_CPU) | sed -e 's/000000.*//')

CC  := /usr/bin/avr-gcc
CXX := /usr/bin/avr-g++
AR  := /usr/bin/avr-ar
CP  := /usr/bin/install

GCC_VERSION := $(shell $(CC) -dumpversion | cut -f1,2 -d. | tr -d '.')
GCC_VERSION_GE_47 := $(shell expr $(GCC_VERSION) \>= 47)

INCDIR = $(PREFIX)/include/arduino
LIBDIR = $(PREFIX)/lib/arduino/$(MCU)/$(MHZ)/$(VARIANT)

SRC_H   := $(wildcard $(SRC)/*.h $(SRC)/utility/*.h)
SRC_C   := $(wildcard $(SRC)/*.c $(SRC)/utility/*.c)
SRC_CPP := $(wildcard $(SRC)/*.cpp $(SRC)/utility/*.cpp)

DEP_H   := $(foreach var,$(DEPS),-I$(INCDIR)/$(var))
DEP_LIB := $(foreach var,$(DEPS),-l$(var))

OBJS = $(SRC_C:.c=.o) $(SRC_CPP:.cpp=.o)
LIB  = lib$(NAME).a

DEFS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -DARDUINO=$(REVISION)
ifdef VID
  DEFS += -DUSB_VID=$(VID) -DUSB_PID=$(PID)
endif

# enable backward compability flag with newer compilers
ifeq ($(GCC_VERSION_GE_47), 1)
  DEFS += -D__AVR_LIBC_DEPRECATED_ENABLE__
endif

CFLAGS = -g -Os -w -ffunction-sections -fdata-sections \
    $(DEFS) -I$(SRC) -I$(SRC)/utility -I$(INCDIR) \
    -I$(INCDIR)/variants/$(VARIANT) $(DEP_H)
CXXFLAGS = -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections \
    $(DEFS) -I$(SRC) -I$(SRC)/utility -I$(INCDIR) \
    -I$(INCDIR)/variants/$(VARIANT) $(DEP_H)

# line feed (note! two blank lines)
define LF


endef

all: $(LIB)

$(LIB): $(OBJS)
	$(AR) rcs $@ $?

install: $(LIB)
	$(CP) -D -C -m 644 $? $(LIBDIR)/$?
	$(CP) -d $(INCDIR)/$(NAME)
	$(foreach var,$(SRC_H),$(CP) -D -C -m 644 $(var) $(INCDIR)/$(NAME)/$(subst $(SRC)/,,$(var))$(LF))

clean:
	$(RM) $(OBJS)
	$(RM) $(LIB)

uninstall:
	$(RM) $(LIBDIR)/$(LIB)
	$(RM) -r $(INCDIR)/$(NAME)
