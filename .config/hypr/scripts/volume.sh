#!/usr/bin/env bash
# ╔═══════════════════════════════════════╗
# ║           scripts/volume.sh           ║
# ╚═══════════════════════════════════════╝
# Usage: volume.sh up | down | mute

STEP=5

case "$1" in
    up)
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ "${STEP}%+"
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%-"
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    *)
        echo "Usage: $0 up|down|mute"
        exit 1
        ;;
esac

# Show notification
VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)

if [[ "$MUTED" -gt 0 ]]; then
    notify-send -h string:x-canonical-private-synchronous:volume \
        -t 1500 "󰝟  Muted"
else
    notify-send -h string:x-canonical-private-synchronous:volume \
        -h int:value:"$VOL" \
        -t 1500 "󰕾  Volume ${VOL}%"
fi
