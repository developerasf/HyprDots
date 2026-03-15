# ╔═══════════════════════════════════════╗
# ║             ~/.zprofile               ║
# ║  Runs on login shell (before .zshrc)  ║
# ╚═══════════════════════════════════════╝
# Ly display manager handles launching Hyprland automatically.
# This file is kept as a fallback — if Ly is ever disabled,
# log into a raw TTY and type `startw` to start Hyprland manually.

# ── Fallback manual start (only if no DM is running) ─────────────────────────
startw() {
    if [[ -z "$WAYLAND_DISPLAY" && -z "$DISPLAY" ]]; then
        exec Hyprland
    else
        echo "Already in a graphical session."
    fi
}

# ── XDG base dirs ─────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
