#!/usr/bin/env bash
# ╔═══════════════════════════════════════╗
# ║         scripts/wallpaper.sh          ║
# ║   swww wallpaper changer              ║
# ║   Called on login + SUPER+W           ║
# ╚═══════════════════════════════════════╝

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
TRANSITION="grow"
TRANSITION_DURATION=1.2
TRANSITION_FPS=60
TRANSITION_POS="0.5,0.5"   # center of screen

# Make sure swww daemon is running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 0.5
fi

# Pick a random wallpaper — skip the current one if possible
CURRENT=$(swww query 2>/dev/null | grep -oP "image: \K.*" | head -1)
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.gif" -o \
    -iname "*.webp" \
\) | grep -v "$CURRENT" | shuf -n1)

# Fallback — if only one wallpaper exists, just use it
if [[ -z "$WALLPAPER" ]]; then
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( \
        -iname "*.jpg" -o \
        -iname "*.jpeg" -o \
        -iname "*.png" -o \
        -iname "*.gif" -o \
        -iname "*.webp" \
    \) | shuf -n1)
fi

if [[ -z "$WALLPAPER" ]]; then
    notify-send -t 3000 "Wallpaper" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Set the wallpaper with grow transition from center
swww img "$WALLPAPER" \
    --transition-type "$TRANSITION" \
    --transition-duration "$TRANSITION_DURATION" \
    --transition-fps "$TRANSITION_FPS" \
    --transition-pos "$TRANSITION_POS"

# Copy as wallpaper.jpg for hyprlock (regardless of original format)
cp "$WALLPAPER" "$HOME/.config/hypr/wallpapers/wallpaper.jpg" 2>/dev/null || true

# Show notification with wallpaper filename
notify-send -t 2000 "🖼  Wallpaper" "$(basename "$WALLPAPER")"
