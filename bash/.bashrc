magickb_is_connected=$(bt-device --info="Magic Keyboard" | grep "Connected" | cut -d " " -f 4)
model=$(setxkbmap -query | grep model | sed 's/model:      //')

if [[ $magickb_is_connected == "1" ]]; then
  magickb_model="macA2450"
  if [ $model != $magickb_model ]; then
    echo "Magic Keyboard connected!"
    echo "Setting Keyboard layout to macA2450"
    #run alias to set keyboard layout
    mackb &> /dev/null
    xbindkeys
  fi

else
  ogkb_model="pc105"
  if [ $model != $ogkb_model ]; then
    echo "Magic Keyboard not connected."
    echo "Setting Keyboard layout to original layout"
    #run alias to set keyboard layout
    ogkb &> /dev/null
  fi
fi
