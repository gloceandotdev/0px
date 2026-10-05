#!/bin/bash
# "bat 84%" on battery, "ac 84%" on power. Gold in Low Power Mode, love when low.

source "$CONFIG_DIR/colors.sh"

batt="$(pmset -g batt)"
pct="$(grep -Eo '[0-9]+%' <<< "$batt" | head -1 | tr -d %)"

# No battery (desktop)
if [ -z "$pct" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

label="${pct}%"

name=bat
grep -q 'AC Power' <<< "$batt" && name=ac

color="$COLOR_TEXT"
[ "$(pmset -g | awk '/ powermode/ { print $2 }')" = 1 ] && color="$COLOR_MARIGOLD"
[ "$pct" -le 20 ] && color="$COLOR_POPPY"

sketchybar --set "$NAME" icon="$name" label="$label" label.color="$color"
