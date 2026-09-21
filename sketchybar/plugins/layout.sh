#!/bin/bash
# Flips every space between bsp and float, based on what the focused space is now.

case "$(yabai -m query --spaces --space | jq -r .type)" in
  float) next=bsp ;;
  *)     next=float ;;
esac

yabai -m config layout "$next"
for idx in $(yabai -m query --spaces | jq -r '.[].index'); do
  yabai -m space "$idx" --layout "$next"
done

sketchybar --trigger spaces_update
