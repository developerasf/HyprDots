#!/usr/bin/env bash
# ╔═══════════════════════════════════════╗
# ║        scripts/brightness.sh          ║
# ╚═══════════════════════════════════════╝
# Usage: brightness.sh up | down

STEP=5

case "$1" in
    up)   brightnessctl set +"${STEP}%" ;;
    down) brightnessctl set "${STEP}%-" ;;
    *)    echo "Usage: $0 up|down"; exit 1 ;;
esac

# Show notification with current level
LEVEL=$(brightnessctl get)
MAX=$(brightnessctl max)
PCT=$(( LEVEL * 100 / MAX ))

notify-send \
    -h string:x-canonical-private-synchronous:brightness \
    -h int:value:"$PCT" \
    -t 1200 \
    "$([ "$PCT" -ge 50 ] && echo "󰃠" || echo "󰃞")  Brightness ${PCT}%"
