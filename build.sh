#! /bin/sh

#  Configurations:
#
# see 'boards.txt' in Arduino dist for combinations
# MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard                       - lilypad328, pro328
# MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard                       - uno, atmega328, ethernet, pro5v328
# MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs              - fio
# MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs              - nano328, mini328, bt328
# MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard                       - lilypad, pro
# MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard                       - diecimila, pro5v, atmega168
# MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs              - mini, nano, bt
# MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega                           - mega2560
# MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega                           - mega
# MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo VID=0x2341 PID=0x8036 - leonardo
# MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard                       - atmega8
#
# additional boards
# MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard                       - sanguino

# core
make -f core.mk clean install MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f core.mk clean install MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f core.mk clean install MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f core.mk clean install MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f core.mk clean install MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f core.mk clean install MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f core.mk clean install MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f core.mk clean install MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f core.mk clean install MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f core.mk clean install MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo USB_VID=0x2341 USB_PID=0x8036
make -f core.mk clean install MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f core.mk clean install MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f core.mk clean

# install backward compability header file
make -f core.mk install_wp

# install build makefile
make -f core.mk install_mk

## libraries

# EEPROM
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=EEPROM DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=EEPROM DEPS=

# SPI
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SPI DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=SPI DEPS=

# Ethernet
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Ethernet DEPS=SPI MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=Ethernet DEPS=SPI

# Firmata
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Firmata DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=Firmata DEPS=

# LiquidCrystal
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=LiquidCrystal DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=LiquidCrystal DEPS=

# SD
make -f library.mk clean install NAME=SD DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SD DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SD DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SD DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SD DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SD DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SD DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SD DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=SD DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=SD DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=SD DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SD DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=SD DEPS=

# Servo
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Servo DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=Servo DEPS=

# SoftwareSerial
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
# these gives errors
#make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=SoftwareSerial DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=SoftwareSerial DEPS=

# Stepper
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Stepper DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=Stepper DEPS=

# Wire
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega328p F_CPU=8000000L  CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega328p F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega168  F_CPU=8000000L  CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega168  F_CPU=16000000L CORE=arduino VARIANT=eightanaloginputs
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega2560 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega1280 F_CPU=16000000L CORE=arduino VARIANT=mega
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega32u4 F_CPU=16000000L CORE=arduino VARIANT=leonardo
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega8    F_CPU=16000000L CORE=arduino VARIANT=standard
make -f library.mk clean install NAME=Wire DEPS= MCU=atmega644p F_CPU=16000000L CORE=arduino VARIANT=standard

make -f library.mk clean NAME=Wire DEPS=
