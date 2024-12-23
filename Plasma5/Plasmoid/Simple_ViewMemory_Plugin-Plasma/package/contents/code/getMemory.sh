#!/bin/bash
# Script just to read memory and format output text.

str=""

# free -k, --kibi : Display output in kibibytes. (1KiB = 1024bytes).
memArray=($(free --kibi | grep ^Mem))

if [[ ${#memArray[@]} -gt 3 ]]; then
    str="${memArray[2]};${memArray[1]};"
fi

echo $str

exit 0
