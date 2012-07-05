#! /bin/sh

# Builds Arduino core and standard libraries for each board configuration
# located in the '/boards' directory.
#
# NB! Generate the boards files first, using the 'conv.sh' script.

DIR="./boards"

install_core () {
    for i in $*
    do
        make -f core.mk clean install BOARD="$i"
    done
    make -f core.mk clean
}

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

# install core
install_core $BOARDS

## install libraries
#               library        deps  boards to exclude
install_library EEPROM         ""    ""                        $BOARDS
install_library SPI            ""    ""                        $BOARDS;
install_library Ethernet       "SPI" ""                        $BOARDS;
install_library Firmata        ""    "atmega12848m atmega1284" $BOARDS;
install_library LiquidCrystal  ""    ""                        $BOARDS;
install_library SD             ""    ""                        $BOARDS;
install_library Servo          ""    ""                        $BOARDS;
install_library SoftwareSerial ""    "atmega8"                 $BOARDS;
install_library Stepper        ""    ""                        $BOARDS;
install_library Wire           ""    ""                        $BOARDS;

# install build makefile
make -f core.mk install_mk

# install backward compability header file
make -f core.mk install_wp
