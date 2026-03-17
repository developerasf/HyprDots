#!/usr/bin/env bash
# ╔═══════════════════════════════════════╗
# ║         scripts/powermenu.sh          ║
# ╚═══════════════════════════════════════╝

LOCK="󰌾  Lock"
SUSPEND="󰒲  Suspend"
REBOOT="󰑓  Reboot"
SHUTDOWN="󰐥  Shutdown"
LOGOUT="󰍃  Logout"

CHOSEN=$(printf '%s\n' "$LOCK" "$SUSPEND" "$REBOOT" "$SHUTDOWN" "$LOGOUT" \
    | rofi -dmenu \
           -p "Power" \
           -theme-str 'window {width: 220px;} listview {lines: 5;}')

case "$CHOSEN" in
    "$LOCK")     loginctl lock-session ;;
    "$SUSPEND")  systemctl suspend ;;
    "$REBOOT")   systemctl reboot ;;
    "$SHUTDOWN")  systemctl poweroff ;;
    "$LOGOUT")   hyprctl dispatch exit ;;
esac
