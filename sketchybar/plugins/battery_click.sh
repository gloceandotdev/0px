#!/bin/bash
# Toggles Low Power Mode. pmset needs root, so setup.sh adds a sudoers entry for exactly this.

if [ "$(pmset -g | awk '/ powermode/ { print $2 }')" = 1 ]; then
  sudo -n pmset -a powermode 0
else
  sudo -n pmset -a powermode 1
fi

sketchybar --update
