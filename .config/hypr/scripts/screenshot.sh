#!/usr/bin/env bash
# ╔═══════════════════════════════════════╗
# ║         scripts/screenshot.sh         ║
# ╚═══════════════════════════════════════╝
# Usage:
#   screenshot.sh area     — select area, copy to clipboard + save file
#   screenshot.sh screen   — full screen
#   screenshot.sh active   — active window

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE="$SAVE_DIR/screenshot_$TIMESTAMP.png"

case "${1:-area}" in
    area)
        grimblast --notify copysave area "$FILE"
        ;;
    screen)
        grimblast --notify copysave screen "$FILE"
        ;;
    active)
        grimblast --notify copysave active "$FILE"
        ;;
    *)
        echo "Usage: $0 area|screen|active"
        exit 1
        ;;
esac
