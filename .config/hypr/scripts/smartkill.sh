#!/bin/bash

# Get active window PID from Hyprland
PID=$(hyprctl activewindow -j | jq -r '.pid')

# If PID exists, try graceful termination
if [ -n "$PID" ] && [ "$PID" != "null" ]; then
    kill "$PID"
fi
