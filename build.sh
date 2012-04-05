#! /bin/sh

export TOP=/usr/local
export VERSION=22

STD_H="
binary.h
HardwareSerial.h
pins_arduino.h
Print.h
Stream.h
WCharacter.h
WConstants.h
wiring.h
wiring_private.h
WProgram.h
WString.h
"

STD_SRC="
wiring_pulse.c
wiring_analog.c
pins_arduino.c
wiring.c
wiring_digital.c
WInterrupts.c
wiring_shift.c
Tone.cpp
main.cpp
WString.cpp
WMath.cpp
Print.cpp
HardwareSerial.cpp
"

SRC="$STD_SRC"

OBJS=`echo $SRC | sed -e 's/\.cpp/.o/g' -e 's/\.c/.o/g'`
export OBJS

HEADERS="$STD_H"
export HEADERS

MCU=atmega328p F_CPU=16000000 make -n install

make -n install_headers
