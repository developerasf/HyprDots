#!/usr/bin/env bash
# ╔═══════════════════════════════════════╗
# ║        scripts/tty-colors.sh          ║
# ║   Sets Tokyo Night palette on TTY     ║
# ║   Sourced by /etc/profile.d/          ║
# ╚═══════════════════════════════════════╝
# This makes Ly (and any TTY session) render in Tokyo Night colors.
# The escape sequences reprogram the terminal's 16-color palette.

# Only run on a real TTY, not inside a graphical terminal
[[ "$(tty)" =~ /dev/tty ]] || return 0

color() {
    # $1 = color index (0–15), $2 = hex color without #
    printf '\e]P%x%s' "$1" "$2"
}

# ── Tokyo Night palette ───────────────────────────────────────────────────────
color  0  15161e   # black          (bg darker)
color  1  f7768e   # red            (errors, delete)
color  2  9ece6a   # green          (success, add)
color  3  e0af68   # yellow         (warning, modified)
color  4  7aa2f7   # blue           (primary accent)
color  5  bb9af7   # magenta        (keywords)
color  6  7dcfff   # cyan           (strings, types)
color  7  a9b1d6   # white          (foreground dim)
color  8  414868   # bright black   (comments)
color  9  f7768e   # bright red
color 10  9ece6a   # bright green
color 11  e0af68   # bright yellow
color 12  7aa2f7   # bright blue
color 13  bb9af7   # bright magenta
color 14  7dcfff   # bright cyan
color 15  c0caf5   # bright white   (main foreground)

# Set background and foreground
printf '\e[40m'    # bg = color 0
printf '\e[97m'    # fg = bright white
clear
