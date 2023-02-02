#Add the following lines to .bashrc
#run alias to set mac keyboard layout
model=$(setxkbmap -query | grep model | sed 's/model:      //')
set_model="macA2450"
if [ $model != $set_model ]; then
  echo "Setting Keyboard layout to macA2450"
  mackb &> /dev/null
fi
