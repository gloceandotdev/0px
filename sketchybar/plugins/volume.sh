#!/bin/bash
# The volume_change event passes the new volume in $INFO; otherwise ask the system.

if [ "$SENDER" = "volume_change" ]; then
  vol="$INFO"
else
  vol="$(osascript -e 'output volume of (get volume settings)')"
fi

if [ "$vol" -eq 0 ]; then
  label=mute
else
  label="${vol}%"
fi

sketchybar --set "$NAME" label="$label"
