#!/bin/bash

source "$CONFIG_DIR/colors.sh"

env_file="$CONFIG_DIR/sketchybar_env"
if [ ! -f "$env_file" ]; then
  sketchybar --set "$NAME" icon="" label="no api key" label.color="$COLOR_MUTED"
  exit 0
fi
source "$env_file"

# The network may not be back yet after a wake, so give it a few tries
for _ in 1 2 3 4 5 6 7 8 9 10; do
  location="$(curl -sf --max-time 5 "http://ip-api.com/json")" && break
  sleep 3
done

lat="$(jq -r '.lat' <<< "$location")"
lon="$(jq -r '.lon' <<< "$location")"
data="$(curl -sf --max-time 10 "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${API_KEY}&units=metric")"

if [ -z "$data" ]; then
  sketchybar --set "$NAME" icon="" label="--" label.color="$COLOR_MUTED"
  exit 0
fi

temp="$(jq -r '.main.temp | floor' <<< "$data")"
cond="$(jq -r '.weather[0].main | ascii_downcase' <<< "$data")"

sketchybar --set "$NAME" icon="$cond" label="${temp}°C" label.color="$COLOR_TEXT"
