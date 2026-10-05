#!/bin/bash

source "$CONFIG_DIR/colors.sh"

args=()
count=0
while IFS=$'\t' read -r idx focus visible windows type; do
  count=$idx
  item="space.$idx"
  if [ "$focus" = true ]; then
    args+=(--set "$item" drawing=on background.drawing=on background.color="$COLOR_FOCUS" label.color="$COLOR_BASE")
    layout="$type"
  elif [ "$visible" = true ]; then
    args+=(--set "$item" drawing=on background.drawing=on background.color="$COLOR_OVERLAY" label.color="$COLOR_TEXT")
  elif [ "$windows" -gt 0 ]; then
    args+=(--set "$item" drawing=on background.drawing=off label.color="$COLOR_TEXT")
  else
    args+=(--set "$item" drawing=on background.drawing=off label.color="$COLOR_MUTED")
  fi
done < <(yabai -m query --spaces 2>/dev/null \
         | jq -r '.[] | [.index, ."has-focus", ."is-visible", (.windows | length), .type] | @tsv')

for ((i = count + 1; i <= 10; i++)); do
  args+=(--set "space.$i" drawing=off)
done

sketchybar "${args[@]}" --set layout label="$layout"
