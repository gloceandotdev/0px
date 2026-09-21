#!/bin/bash

sketchybar --set "$NAME" label="$(date +'%a %d %b %H:%M')" \
                         update_freq="$((60 - $(date +%s) % 60))"
