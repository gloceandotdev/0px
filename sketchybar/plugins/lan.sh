#!/bin/bash
# Lit when a wired interface (any en* that is not Wi-Fi) is up with an address.

source "$CONFIG_DIR/colors.sh"

wifi_dev="$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/ { getline; print $2 }')"

up=false
for ifc in $(ifconfig -lu); do
  case "$ifc" in
    en*)
      [ "$ifc" = "$wifi_dev" ] && continue
      if ifconfig "$ifc" | grep -q 'status: active' && ifconfig "$ifc" | grep -q 'inet '; then
        up=true
        break
      fi
      ;;
  esac
done

if [ "$up" = true ]; then
  sketchybar --set "$NAME" label.color="$COLOR_DEW"
else
  sketchybar --set "$NAME" label.color="$COLOR_MUTED"
fi
