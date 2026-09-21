#!/bin/bash

source "$CONFIG_DIR/colors.sh"

up=false
scutil --nc list 2>/dev/null | grep -q '(Connected)' && up=true

if [ "$up" = false ]; then
  for ifc in $(ifconfig -lu); do
    case "$ifc" in
      utun*) ifconfig "$ifc" | grep -q 'inet ' && { up=true; break; } ;;
    esac
  done
fi

if [ "$up" = true ]; then
  sketchybar --set "$NAME" label.color="$COLOR_FOAM"
else
  sketchybar --set "$NAME" label.color="$COLOR_MUTED"
fi
