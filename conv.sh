#! /bin/sh

# Converts an Arduino 'board.txt' file into a set of files of variable
# definitions, one for each board, suitable for Makefile inclusion.

if [ $# != 1 ]
then
    echo "Usage: $(basename $0) <board.txt>"
    exit 1
fi

FILE=$1
DIR=boards

# holds current board type
board=

filter () {
    echo $1 | egrep -q '(^ *#|^ *$|bootloader)'
}

match () {
    echo $1 | egrep -q "$2"
}

get_first () {
    echo $1 | sed -e 's/\..*//'
}

get_last () {
    echo $1 | sed -e 's/.*\.//'
}

upcase () {
    echo $1 | tr 'a-z' 'A-Z'
}

warn () {
    echo $1
}

output () {
    key=$(echo $1 | sed -e 's/=.*//')
    value=$(echo $1 | sed -e 's/.*=//')

    if match $key "name" -a $(get_first $key) != $board
    then
        board=$(get_first $key)
        # tell it if a configuration file already exists
        test -f $DIR/$board.inc && \
            warn "The file \"$DIR/$board.inc\" exists, will be overwritten"
    fi

    key=$(get_last $key)
    key=$(upcase $key)

    if match $key "NAME"
    then
        echo "# $value" >> $DIR/$board.inc
    else
        echo "$key = $value" >> $DIR/$board.inc
    fi
}

test -d $DIR || mkdir -p $DIR

while read line
do
    # skip blank, comments and 'bootloader' lines
    filter "$line" && continue

    # write 'inc' file, one per board
    output "$line"
done < $FILE
