#! /bin/sh

# Builds external libraries for Arduino. The building is done for each board
# configuration located in the 'boards' directory.

# defaults for Arduino ver. 1.0.3
export PREFIX=/usr/local
export ROOT=.
export VERSION=103

# directory containing the 'board' definition files
DIR="$PREFIX/lib/arduino/boards"

exclude_board () {
    BOARD=$1; shift
    for j in $*
    do
        test $j = $BOARD && return 1
    done
    return 0
}

install_library () {
    NAME=$1; shift
    DEPS=$1; shift
    EXCL=$1; shift
    # directory containing library source
    export SRC=$ROOT/$NAME
    for i in $*
    do
        exclude_board $i $EXCL
        if [ $? -eq 0 ]
        then
            make -f library.mk clean install NAME="$NAME" DEPS="$DEPS" BOARD="$i"
        fi
    done
    make -f library.mk clean NAME="$NAME" DEPS="$DEPS"
}

# get list of boards
BOARDS=$(echo $DIR/*.inc | sed -e "s#$DIR/*##g" -e 's/\.inc//g')

## install libraries
#               library                 deps              boards to exclude
install_library LedControl              ""                ""                                 $BOARDS
install_library TM1638                  ""                ""                                 $BOARDS
install_library USBHostShield           ""                "atmega8 atmega12848m atmega1284"  $BOARDS
install_library AdafruitThermalPrinter  "SoftwareSerial"  ""                                 $BOARDS
