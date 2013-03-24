#! /bin/sh

# Builds Arduino core and standard libraries for each board configuration
# located in the '/boards' directory.
#
# NB! Generate the boards files first, using the 'conv.sh' script.

# locations
export PREFIX=/usr/local

# defaults for Arduino ver. 1.0.3
export ROOT=./arduino-1.0.3
export REVISION=103

. ./init-functions

# get list of boards
BOARDS=$(echo ./boards/*.inc | sed -e 's/[^ ]*\///g' -e 's/\.inc//g')

# install core
install_core $BOARDS

## install libraries
#               library        deps  boards to build, default is all boards
#                                    (a '!' at the beginning inverts)
install_library EEPROM         ""    ""                                           $BOARDS
install_library Esplora        ""    "esplora leonardo LilyPadUSB mega2560 mega"  $BOARDS
install_library SPI            ""    ""                                           $BOARDS
install_library Ethernet       "SPI" ""                                           $BOARDS
install_library Firmata        ""    "!atmega12848m atmega1284"                   $BOARDS
install_library LiquidCrystal  ""    ""                                           $BOARDS
install_library SD             ""    ""                                           $BOARDS
install_library Servo          ""    ""                                           $BOARDS
install_library SoftwareSerial ""    "!atmega8"                                   $BOARDS
install_library Stepper        ""    ""                                           $BOARDS
install_library WiFi           ""    ""                                           $BOARDS
install_library Wire           ""    ""                                           $BOARDS

# install files
make -f core.mk install_files
