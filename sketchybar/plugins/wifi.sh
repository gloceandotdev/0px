#!/bin/bash

source "$CONFIG_DIR/colors.sh"

dev="$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/ { getline; print $2 }')"
state="${TMPDIR:-/tmp}/sketchybar-wifi-$dev"

if ! ifconfig "$dev" 2>/dev/null | grep -q 'status: active'; then
  rm -f "$state"
  sketchybar --set "$NAME" label="down" label.color="$COLOR_MUTED"
  exit 0
fi

human() {
  local b=$1
  if   [ "$b" -lt 1024 ];    then echo "${b}B"
  elif [ "$b" -lt 1048576 ]; then echo "$((b / 1024))K"
  else printf '%.1fM\n' "$(bc -l <<< "$b / 1048576")"
  fi
}

now="$(date +%s)"
read -r rx tx <<< "$(netstat -ibn -I "$dev" | awk 'NR == 2 { print $7, $10 }')"

label=up
if [ -f "$state" ]; then
  read -r then rx0 tx0 < "$state"
  dt=$((now - then))
  if [ "$dt" -gt 0 ]; then
    label="↓$(human $(( (rx - rx0) / dt ))) ↑$(human $(( (tx - tx0) / dt )))"
  fi
fi
echo "$now $rx $tx" > "$state"

sketchybar --set "$NAME" label="$label" label.color="$COLOR_TEXT"
