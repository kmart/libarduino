PREFIX  = /usr/local
VERSION = 22

MCU   = atmega328p
F_CPU = 16000000

# the lines below will most likely not require any changes

INCLUDE = $(PREFIX)/include/arduino

CC  = /usr/bin/avr-gcc
CXX = /usr/bin/avr-g++
AR  = /usr/bin/avr-ar
CP  = cp -d --preserve=all

SRC = src

SRC_C   = $(shell echo $(SRC)/*.c)
SRC_CPP = $(shell echo $(SRC)/*.cpp)

OBJS  = $(SRC_C:.c=.o) $(SRC_CPP:.cpp=.o)
HDRS  = $(shell echo src/*.h)

MHZ = $(shell echo $(F_CPU) | sed -e 's/000000//')
LIB = libarduino-$(MCU)_$(MHZ).a

AFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION)

CFLAGS   = -g -Os -w -ffunction-sections -fdata-sections $(AFLAGS) -I$(SRC)
CXXFLAGS = -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections  \
    $(AFLAGS) -I$(SRC)

all: $(LIB)

$(LIB): $(OBJS)
	$(AR) rcs $@ $?

install: $(LIB)
	$(CP) $? $(PREFIX)/lib/$?

install_headers:
	$(CP) $(HDRS) $(INCLUDE)

install_mk: arduino.mk
	$(CP) $? $(PREFIX)/lib/$?

clean:
	$(RM) $(OBJS)

realclean: clean
	$(RM) libarduino-*.a
