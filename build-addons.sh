#! /bin/sh

# Builds external libraries for Arduino. The building is done for each board
# configuration located in the 'boards' directory.

# locations
export PREFIX=/usr/local
export ROOT=.
export LIB=$PREFIX/lib/arduino

. $LIB/init-functions

# get list of boards
BOARDS=$(echo $LIB/boards/*.inc | sed -e 's/[^ ]*\///g' -e 's/\.inc//g')

## install addon libraries
#             library                 deps              boards to build, default is all boards
#                                                         (a '!' at the beginning inverts)
install_addon LedControl              ""                ""                                               $BOARDS
install_addon TM1638                  ""                ""                                               $BOARDS
install_addon USBHostShield           ""                "!atmega8 atmega12848m atmega1284 robotControl"  $BOARDS
install_addon AdafruitThermalPrinter  "SoftwareSerial"  ""                                               $BOARDS
install_addon Sha                     ""                ""                                               $BOARDS
