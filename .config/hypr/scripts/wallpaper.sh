#!/usr/bin/env bash
# ╔═══════════════════════════════════════╗
# ║         scripts/wallpaper.sh          ║
# ╚═══════════════════════════════════════╝
# Sets a random wallpaper from ~/.config/hypr/wallpapers/
# Run manually to cycle: bash ~/.config/hypr/scripts/wallpaper.sh

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
TRANSITION="wipe"          # fade | wipe | slide | grow | outer
TRANSITION_DURATION=1.5

# Pick random image
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n1)

if [[ -z "$WALLPAPER" ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Copy chosen wallpaper as wallpaper.jpg so hyprlock always finds it
cp "$WALLPAPER" "$HOME/.config/hypr/wallpapers/wallpaper.jpg" 2>/dev/null || true

swww img "$WALLPAPER" \
    --transition-type "$TRANSITION" \
    --transition-duration "$TRANSITION_DURATION" \
    --transition-fps 60
