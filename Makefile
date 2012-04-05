INCLUDE = $(TOP)/include/arduino

CC  = /usr/bin/avr-gcc
CXX = /usr/bin/avr-g++
AR  = /usr/bin/avr-ar
CP  = cp -d --preserve=all

LIB = libarduino-$(MCU).a

AFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION)

CFLAGS   = -g -Os -w -ffunction-sections -fdata-sections $(AFLAGS) -I$(INCLUDE)
CXXFLAGS = -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections $(AFLAGS) \
    -I$(INCLUDE)

all: $(LIB)

$(LIB): $(OBJS)
	$(AR) rcs $@ $?

install: $(LIB)
	$(CP) $? $(TOP)/lib/$?

install_headers:
	$(CP) $(HEADERS) $(INCLUDE)

clean:
	$(RM) $(OBJS)

realclean: clean
	$(RM) $(LIB)
