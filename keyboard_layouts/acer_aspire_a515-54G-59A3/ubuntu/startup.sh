#!/bin/bash
dir="/home/andre/Downloads/Linux_Configs/keyboard_layouts/acer_aspire_a515-54G-59A3/ubuntu"


file=$dir/.keyboard_bool
touch $file
xkbcomp $dir/macA2450.xkb $DISPLAY

killall -HUP xbindkeys && xbindkeys
