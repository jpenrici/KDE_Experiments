#!/bin/bash
# Script just to read memory and format output text.

str=""
memArray=($(free --giga | grep ^Mem))

if [[ ${#memArray[@]} -gt 3 ]]; then
    str="${memArray[2]};${memArray[1]};"
fi

echo $str

exit 0
