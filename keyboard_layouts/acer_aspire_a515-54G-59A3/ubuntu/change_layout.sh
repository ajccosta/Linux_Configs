#!/bin/bash
dir="$HOME/.config/Linux_Configs/keyboard_layouts/acer_aspire_a515-54G-59A3/ubuntu"

file=$dir/.keyboard_bool

if test -f "$file"; then
    rm $file
    xkbcomp $dir/macA2450_FKeys.xkb $DISPLAY
else
    touch $file
    xkbcomp $dir/macA2450.xkb $DISPLAY
fi

