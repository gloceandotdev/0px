#!/bin/bash
# "sleep" normally, gold "awake" while sleep is disabled. Click toggles it
# (needs the pmset sudoers entry from setup.sh).

source "$CONFIG_DIR/colors.sh"

disabled="$(pmset -g | awk '/SleepDisabled/ { print $2 }')"

if [ "$SENDER" = mouse.clicked ]; then
  if [ "$disabled" = 1 ]; then
    sudo -n pmset -a disablesleep 0 && disabled=0
  else
    sudo -n pmset -a disablesleep 1 && disabled=1
  fi
fi

if [ "$disabled" = 1 ]; then
  sketchybar --set "$NAME" label=awake label.color="$COLOR_GOLD"
else
  sketchybar --set "$NAME" label=sleep label.color="$COLOR_TEXT"
fi
