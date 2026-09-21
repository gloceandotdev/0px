#!/bin/bash
# switch-theme.sh - called by dark-notify on appearance change, or manually with "dark"/"light"

CONFIG="$HOME/.config"

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

MODE="${1:-}"
if [ -z "$MODE" ]; then
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi dark; then
        MODE="dark"
    else
        MODE="light"
    fi
fi

case "$MODE" in
    dark)
        # Sketchybar
        cp "$CONFIG/sketchybar/colors-dark.sh" "$CONFIG/sketchybar/colors.sh"
        sketchybar --reload

        # Fish (the prompt reads $rice_theme)
        fish -c 'fish_config theme choose "Rosé Pine"; set -U rice_theme dark' 2>/dev/null
        sed -i '' 's/^set --global fish_color_command .*/set --global fish_color_command c4a7e7/' "$CONFIG/fish/conf.d/fish_frozen_theme.fish"

        # JankyBorders
        sed -i '' 's/^borders active_color=.*/borders active_color=0xffc4a7e7 inactive_color=0xff6e6a86 width=4.0 style=square hidpi=on/' "$CONFIG/yabai/yabairc"
        pkill -x borders 2>/dev/null; sleep 0.2
        nohup /opt/homebrew/bin/borders active_color=0xffc4a7e7 inactive_color=0xff6e6a86 width=4.0 style=square hidpi=on >/dev/null 2>&1 &
        ;;

    light)
        # Sketchybar
        cp "$CONFIG/sketchybar/colors-dawn.sh" "$CONFIG/sketchybar/colors.sh"
        sketchybar --reload

        # Fish (the prompt reads $rice_theme)
        fish -c 'fish_config theme choose "Rosé Pine Dawn"; set -U rice_theme light' 2>/dev/null
        sed -i '' 's/^set --global fish_color_command .*/set --global fish_color_command 907aa9/' "$CONFIG/fish/conf.d/fish_frozen_theme.fish"

        # JankyBorders
        sed -i '' 's/^borders active_color=.*/borders active_color=0xff575279 inactive_color=0xff9893a5 width=4.0 style=square hidpi=on/' "$CONFIG/yabai/yabairc"
        pkill -x borders 2>/dev/null; sleep 0.2
        nohup /opt/homebrew/bin/borders active_color=0xff575279 inactive_color=0xff9893a5 width=4.0 style=square hidpi=on >/dev/null 2>&1 &
        ;;
esac
