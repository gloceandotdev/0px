#!/bin/bash
# Focused window: app name in the icon, window title in the label.

win="$(yabai -m query --windows --window 2>/dev/null)"

if [ -z "$win" ]; then
  sketchybar --set "$NAME" icon="" label=""
  exit 0
fi

app="$(jq -r '.app' <<< "$win")"
title="$(jq -r '.title' <<< "$win")"

# Skip the title when it just repeats the app name
[ "$title" = "$app" ] && title=""

sketchybar --set "$NAME" icon="$app" label="$title"
