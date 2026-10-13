#!/bin/bash
# Switch caelestia to the wallpaper-based "dynamic" scheme.
# Dynamic needs a wallpaper to read colours from, so set the shell's default one if none is set yet.
state="${XDG_STATE_HOME:-$HOME/.local/state}/caelestia"
[[ -s $state/wallpaper/path.txt ]] || caelestia wallpaper -f /etc/xdg/quickshell/caelestia/assets/wallpaper.webp
caelestia scheme set -n dynamic
