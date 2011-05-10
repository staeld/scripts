#!/bin/bash
# change colours in conkyrc
# usage: $0 CONKYRC COLOUR
# colours: dark light lighter grey brown red  black

case "$1" in
    "-h"|"--help"|"help"|"")
        echo Usage: $0 conkyrc colour
        echo Colours: $(egrep "^# colours: " $0 | sed -e 's,^.*:,,')
        exit 0
    ;;
esac

conkyrc="$1"
if [ ! -e $conkyrc ]; then
    echo error: $conkyrc does not exist!
    exit 1
fi

function setcolour () {
    echo Setting colour to $1..
    sed -e "s/^default_color ....../default_color $1/" -i $conkyrc
}

colour="$2"
case $colour in
    dark)
        setcolour 333333
    ;;
    light)
        setcolour 9f907d
    ;;
    lighter)
        setcolour c5b088
    ;;
    grey)
        setcolour 656565
    ;;
    brown)
        setcolour 786520
    ;;
    red)
        setcolour ca4040
    ;;
    green)
        setcolour 40ca40
    ;;
    black)
        setcolour 151515
    ;;
    *)
        echo Invalid colour name!
    ;;
esac
