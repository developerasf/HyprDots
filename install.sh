#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║                    HyprDots — install.sh                        ║
# ║           Tokyo Night · Intel iGPU · Full-stack dev             ║
# ║                                                                  ║
# ║  Usage:  bash install.sh                                         ║
# ║                                                                  ║
# ║  • Safe on a fresh Arch install                                  ║
# ║  • Safe on an existing system — skips anything already done      ║
# ║  • Only deploys configs for tools that are installed             ║
# ║  • Existing configs backed up, never deleted                     ║
# ║  • Re-runnable any number of times                               ║
# ╚══════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ── Terminal colors ───────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${BLUE}${BOLD}[INFO]${RESET}  $*"; }
ok() { echo -e "${GREEN}${BOLD}[ OK ]${RESET}  $*"; }
skip() { echo -e "${CYAN}${BOLD}[SKIP]${RESET}  $*"; }
warn() { echo -e "${YELLOW}${BOLD}[WARN]${RESET}  $*"; }
error() {
    echo -e "${RED}${BOLD}[ERR ]${RESET}  $*"
    exit 1
}
step() { echo -e "\n${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n    $*\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
SKIPPED=0
INSTALLED=0
CONFIGURED=0

# ── Check if a package is installed by name OR by what it provides ─────────
pkg_installed() {
    local pkg="$1"
    # Direct name match
    pacman -Qi "$pkg" &>/dev/null && return 0
    # Check if any installed package provides this (handles -bin vs base conflicts)
    pacman -Qqo "$pkg" &>/dev/null && return 0
    # Check provides field — catches lazydocker-bin providing lazydocker, etc.
    pacman -Qq | xargs -I{} pacman -Qi {} 2>/dev/null |
        grep -q "^Provides.*[: ]${pkg}[ $]" && return 0
    return 1
}

# ── pacman: install one package, skip if already present ─────────────────────
pacman_install() {
    local pkg="$1"
    if pacman -Qi "$pkg" &>/dev/null; then
        skip "pacman: $pkg"
        ((SKIPPED++)) || true
    else
        info "pacman: installing $pkg ..."
        # --noconfirm --ask=4 suppresses ALL prompts including provider selection
        sudo pacman -S --needed --noconfirm --ask=4 "$pkg"
        ok "pacman: $pkg installed"
        ((INSTALLED++)) || true
    fi
}

# ── AUR: install one package, skip if already present (any variant) ──────────
aur_install() {
    local pkg="$1"
    # Aliases: some AUR packages have -bin, -git variants that conflict with base name
    # Pass alternate names to check as extra args: aur_install foo foo-bin foo-git
    local check_names=("$@")
    for name in "${check_names[@]}"; do
        if pacman -Qi "$name" &>/dev/null; then
            skip "AUR: $pkg (installed as $name)"
            ((SKIPPED++)) || true
            return
        fi
    done
    info "AUR: installing $pkg ..."
    yay -S --needed --noconfirm \
        --answerdiff=None --answerclean=None \
        --answerupgrade=None \
        --removemake --cleanafter \
        --noredownload \
        "$pkg"
    ok "AUR: $pkg installed"
    ((INSTALLED++)) || true
}

# ── Symlink config — backup existing, skip if symlink already correct ─────────
link_config() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        skip "config: $(basename "$dst")"
        ((SKIPPED++)) || true
        return
    fi

    if [[ -e "$dst" || -L "$dst" ]]; then
        local rel="${dst#"$HOME"/}"
        mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
        cp -r "$dst" "$BACKUP_DIR/$rel" 2>/dev/null
        info "Backed up: $dst"
        rm -rf "$dst"
    fi

    ln -sf "$src" "$dst"
    ok "config: linked $(basename "$dst")"
    ((CONFIGURED++)) || true
}

# ── Copy system file (needs sudo) — skip if already identical ────────────────
system_copy() {
    local src="$1"
    local dst="$2"
    sudo mkdir -p "$(dirname "$dst")"
    if [[ -f "$dst" ]] && diff -q "$src" "$dst" &>/dev/null; then
        skip "system: $dst"
        ((SKIPPED++)) || true
    else
        sudo cp "$src" "$dst"
        ok "system: $dst"
        ((CONFIGURED++)) || true
    fi
}

# ── Enable systemd service — skip if already enabled ─────────────────────────
enable_service() {
    local svc="$1"
    if systemctl is-enabled "$svc" &>/dev/null; then
        skip "service: $svc"
        ((SKIPPED++)) || true
    else
        sudo systemctl enable "$svc"
        ok "service: $svc enabled"
        ((CONFIGURED++)) || true
    fi
}

# ── Add user to group — skip if already member ───────────────────────────────
add_group() {
    local grp="$1"
    if groups "$USER" | grep -qw "$grp"; then
        skip "group: $USER already in $grp"
        ((SKIPPED++)) || true
    else
        sudo usermod -aG "$grp" "$USER"
        ok "group: added $USER → $grp (re-login to activate)"
        ((CONFIGURED++)) || true
    fi
}

# ════════════════════════════════════════════════════════════════════
step "1 / 9  Preflight checks"
# ════════════════════════════════════════════════════════════════════

[[ "$(id -u)" == "0" ]] && error "Do not run as root. Run as your normal user."
command -v pacman &>/dev/null || error "This script is for Arch Linux only."

ok "User:         $(whoami)"
ok "Dotfiles dir: $DOTFILES_DIR"
ok "Backup dir:   $BACKUP_DIR"

if pacman -Qg base-devel &>/dev/null; then
    skip "base-devel"
else
    info "Installing base-devel..."
    sudo pacman -S --needed --noconfirm --ask=4 base-devel
    ok "base-devel installed"
fi

pacman_install git
pacman_install curl

# ════════════════════════════════════════════════════════════════════
step "2 / 9  AUR helper — yay"
# ════════════════════════════════════════════════════════════════════

if command -v yay &>/dev/null; then
    skip "yay ($(yay --version | head -1))"
    ((SKIPPED++)) || true
else
    info "Building yay-bin from AUR..."
    cd /tmp && rm -rf yay-bin
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    ok "yay installed"
    ((INSTALLED++)) || true
fi

# ════════════════════════════════════════════════════════════════════
step "3 / 9  pacman packages"
# ════════════════════════════════════════════════════════════════════
# NOTE: pandoc is intentionally NOT here — the pacman version pulls
# 229 Haskell packages (~500MB). We install pandoc-bin from AUR instead.
# NOTE: virtualbox-host-modules-arch installed BEFORE virtualbox to
# prevent pacman selecting virtualbox-host-dkms as the provider.

# ── Hyprland core ─────────────────────────────────────────────────────────────
pacman_install hyprland
pacman_install xdg-desktop-portal-hyprland
pacman_install polkit-kde-agent
pacman_install qt5-wayland
pacman_install qt6-wayland

# ── Bar / launcher / notifications ────────────────────────────────────────────
pacman_install waybar
pacman_install dunst
pacman_install libnotify

# ── Lock / idle ───────────────────────────────────────────────────────────────
pacman_install hyprlock
pacman_install hypridle

# ── Terminal + shell ──────────────────────────────────────────────────────────
pacman_install kitty
pacman_install zsh
pacman_install starship
pacman_install zsh-autosuggestions
pacman_install zsh-syntax-highlighting

# ── Editor + dev tools ────────────────────────────────────────────────────────
pacman_install neovim
pacman_install lazygit
pacman_install github-cli
pacman_install ripgrep
pacman_install fd

# ── Docker ────────────────────────────────────────────────────────────────────
pacman_install docker
pacman_install docker-compose

# ── Language toolchains ───────────────────────────────────────────────────────
pacman_install nodejs
pacman_install npm
pacman_install pnpm
pacman_install typescript
pacman_install python
pacman_install python-pip
pacman_install python-virtualenv
pacman_install gcc
pacman_install gdb
pacman_install go
pacman_install jdk-openjdk

# ── Files + media ─────────────────────────────────────────────────────────────
pacman_install thunar
pacman_install gvfs
pacman_install mpv
pacman_install imv
pacman_install firefox

# ── System utilities ──────────────────────────────────────────────────────────
pacman_install cliphist
pacman_install wl-clipboard
pacman_install xdg-utils # xdg-mime for default app associations
pacman_install brightnessctl
pacman_install pipewire
pacman_install wireplumber
pacman_install pipewire-pulse
pacman_install pavucontrol
pacman_install htop
pacman_install btop
pacman_install man-db
pacman_install man-pages
pacman_install playerctl
pacman_install bat
pacman_install git-delta
pacman_install p7zip
pacman_install unzip
pacman_install nwg-look

# ── VirtualBox — install host modules FIRST to lock in the provider ───────────
# Installing virtualbox-host-modules-arch first prevents pacman from
# auto-selecting virtualbox-host-dkms (which needs kernel headers)
pacman_install virtualbox-host-modules-arch
pacman_install virtualbox

# ── Sunshine dependency ───────────────────────────────────────────────────────
pacman_install avahi

# ── PDF + office ──────────────────────────────────────────────────────────────
pacman_install zathura
pacman_install zathura-pdf-mupdf
pacman_install libreoffice-fresh
# pandoc intentionally skipped here — installed as pandoc-bin in AUR section

# ── Fonts + icons ─────────────────────────────────────────────────────────────
pacman_install papirus-icon-theme
pacman_install ttf-jetbrains-mono-nerd
pacman_install ttf-font-awesome
pacman_install noto-fonts
pacman_install noto-fonts-emoji

# ════════════════════════════════════════════════════════════════════
step "4 / 9  AUR packages"
# ════════════════════════════════════════════════════════════════════
# yay flags:
#   --answerdiff=None      skip PKGBUILD diff prompt
#   --answerclean=None     skip clean build prompt
#   --removemake           remove make-only deps after build
#   --cleanafter           clean build cache after install
#   --noredownload         don't re-download if cached

aur_install awww
aur_install yazi
aur_install grimblast-git grimblast grimblast-git    # check both names — AUR installs as grimblast-git
aur_install lazydocker-bin lazydocker lazydocker-bin # lazydocker already installed → skip
aur_install visual-studio-code-bin visual-studio-code-bin code
aur_install rofi-wayland rofi-wayland rofi
aur_install sunshine-bin sunshine-bin sunshine # prebuilt bin — source build often fails
aur_install catppuccin-gtk-theme-mocha
aur_install unarchiver
aur_install ly-bin
aur_install icu76
aur_install brave-bin
aur_install localsend-bin

# pandoc-bin: prebuilt binary — installs in seconds, zero Haskell dependencies
# (pandoc from pacman = 229 haskell packages, ~500MB — avoid it)
aur_install pandoc-bin pandoc-bin pandoc

# ════════════════════════════════════════════════════════════════════
step "5 / 9  Manual tools — nvm · pyenv · rustup"
# ════════════════════════════════════════════════════════════════════

# ── nvm ───────────────────────────────────────────────────────────────────────
if [[ -d "$HOME/.nvm" ]]; then
    skip "nvm (already at ~/.nvm)"
    ((SKIPPED++)) || true
else
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh" || true
    nvm install --lts
    ok "nvm + Node LTS installed"
    ((INSTALLED++)) || true
fi

# ── pyenv ─────────────────────────────────────────────────────────────────────
if [[ -d "$HOME/.pyenv" ]]; then
    skip "pyenv (already at ~/.pyenv)"
    ((SKIPPED++)) || true
else
    info "Installing pyenv..."
    curl https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    ok "pyenv installed"
    ((INSTALLED++)) || true
fi

# ── rustup ────────────────────────────────────────────────────────────────────
if command -v rustup &>/dev/null; then
    skip "rustup ($(rustup --version 2>/dev/null | head -1))"
    ((SKIPPED++)) || true
else
    info "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env" || true
    ok "rustup + stable toolchain installed"
    ((INSTALLED++)) || true
fi

# ════════════════════════════════════════════════════════════════════
step "6 / 9  Link dotfiles"
# ════════════════════════════════════════════════════════════════════

info "Backup dir: $BACKUP_DIR"

link_config "$DOTFILES_DIR/.config/hypr" "$HOME/.config/hypr"
link_config "$DOTFILES_DIR/.config/waybar" "$HOME/.config/waybar"
link_config "$DOTFILES_DIR/.config/rofi" "$HOME/.config/rofi"
link_config "$DOTFILES_DIR/.config/dunst" "$HOME/.config/dunst"
link_config "$DOTFILES_DIR/.config/kitty" "$HOME/.config/kitty"
link_config "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

mkdir -p "$HOME/.config/Code/User"
link_config "$DOTFILES_DIR/.config/Code/User/settings.json" \
    "$HOME/.config/Code/User/settings.json"

mkdir -p "$HOME/.config/lazygit"
link_config "$DOTFILES_DIR/.config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

link_config "$DOTFILES_DIR/.config/mpv" "$HOME/.config/mpv"
link_config "$DOTFILES_DIR/.config/yazi" "$HOME/.config/yazi"
link_config "$DOTFILES_DIR/.config/zathura" "$HOME/.config/zathura"
link_config "$DOTFILES_DIR/.config/btop" "$HOME/.config/btop"
link_config "$DOTFILES_DIR/.config/starship/starship.toml" \
    "$HOME/.config/starship.toml"
link_config "$DOTFILES_DIR/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
link_config "$DOTFILES_DIR/.config/gtk-4.0" "$HOME/.config/gtk-4.0"

mkdir -p "$HOME/.config/environment.d"
link_config "$DOTFILES_DIR/.config/environment.d/hyprland.conf" \
    "$HOME/.config/environment.d/hyprland.conf"

link_config "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
link_config "$DOTFILES_DIR/home/.zprofile" "$HOME/.zprofile"
link_config "$DOTFILES_DIR/home/.editorconfig" "$HOME/.editorconfig"

# .gitconfig — preserve real config, only link placeholder if nothing there
if [[ ! -f "$HOME/.gitconfig" && ! -L "$HOME/.gitconfig" ]]; then
    link_config "$DOTFILES_DIR/home/.gitconfig" "$HOME/.gitconfig"
    warn ".gitconfig linked — edit name/email inside it"
elif grep -q "Your Name" "$HOME/.gitconfig" 2>/dev/null; then
    link_config "$DOTFILES_DIR/home/.gitconfig" "$HOME/.gitconfig"
    warn ".gitconfig still has placeholder values — edit name/email"
else
    skip "~/.gitconfig (real config preserved)"
    ((SKIPPED++)) || true
fi

# Docker daemon config
if pacman -Qi docker &>/dev/null; then
    system_copy "$DOTFILES_DIR/.config/docker/daemon.json" "/etc/docker/daemon.json"
else
    skip "Docker daemon config (docker not installed)"
    ((SKIPPED++)) || true
fi

ok "All dotfiles processed"

# ════════════════════════════════════════════════════════════════════
step "7 / 9  Ly display manager"
# ════════════════════════════════════════════════════════════════════

if pacman -Qi ly &>/dev/null; then
    info "Configuring Ly..."
    LY_CONF="$DOTFILES_DIR/.config/ly/config.ini"
    LY_DEST="/etc/ly/config.ini"
    sudo mkdir -p /etc/ly

    RENDERED=$(sed "s/^default_user =$/default_user = $(whoami)/" "$LY_CONF")

    if [[ -f "$LY_DEST" ]] && diff -q <(echo "$RENDERED") "$LY_DEST" &>/dev/null; then
        skip "Ly config (unchanged)"
        ((SKIPPED++)) || true
    else
        echo "$RENDERED" | sudo tee "$LY_DEST" >/dev/null
        ok "Ly config → $LY_DEST (user=$(whoami))"
        ((CONFIGURED++)) || true
    fi

    LY_SAVE="/etc/ly/save"
    EXPECTED="hyprland:$(whoami)"
    CURRENT_SAVE="$(sudo cat "$LY_SAVE" 2>/dev/null || echo '')"
    if [[ "$CURRENT_SAVE" == "$EXPECTED" ]]; then
        skip "Ly save file (unchanged)"
        ((SKIPPED++)) || true
    else
        echo "$EXPECTED" | sudo tee "$LY_SAVE" >/dev/null
        ok "Ly save file → session=hyprland user=$(whoami)"
        ((CONFIGURED++)) || true
    fi

    for DM in gdm sddm lightdm xdm lxdm wdm nodm greetd display-manager; do
        if systemctl is-enabled "${DM}.service" &>/dev/null; then
            sudo systemctl disable "${DM}.service"
            ok "Disabled conflicting DM: $DM"
        fi
    done

    # Disable getty on tty2 — required or Ly will conflict with it
    if systemctl is-enabled getty@tty2.service &>/dev/null; then
        sudo systemctl disable getty@tty2.service
        ok "getty@tty2.service disabled (required for Ly on tty2)"
    fi

    # Enable Ly — correct service name is ly@tty2.service (not ly.service)
    enable_service ly@tty2.service
else
    skip "Ly config (ly not installed)"
    ((SKIPPED++)) || true
fi

system_copy "$DOTFILES_DIR/.config/hypr/scripts/tty-colors.sh" \
    "/etc/profile.d/tty-colors.sh"
sudo chmod +x /etc/profile.d/tty-colors.sh

# ════════════════════════════════════════════════════════════════════
step "8 / 9  System configuration"
# ════════════════════════════════════════════════════════════════════

chmod +x "$DOTFILES_DIR/.config/hypr/scripts/"*.sh
ok "Hypr scripts made executable"

# Default shell → zsh
ZSH_PATH="$(command -v zsh)"
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    skip "Default shell (already zsh)"
    ((SKIPPED++)) || true
else
    chsh -s "$ZSH_PATH"
    ok "Default shell → zsh (takes effect on next login)"
    ((CONFIGURED++)) || true
fi

# Docker
if pacman -Qi docker &>/dev/null; then
    enable_service docker.service
    if ! systemctl is-active docker.service &>/dev/null; then
        sudo systemctl start docker.service
        ok "Docker service started"
    else
        skip "Docker service (already running)"
        ((SKIPPED++)) || true
    fi
    add_group docker
else
    skip "Docker setup (not installed)"
    ((SKIPPED++)) || true
fi

# VirtualBox
if pacman -Qi virtualbox &>/dev/null; then
    add_group vboxusers
    if lsmod | grep -q vboxdrv; then
        skip "VirtualBox kernel module (already loaded)"
        ((SKIPPED++)) || true
    else
        sudo modprobe vboxdrv &&
            ok "VirtualBox kernel module loaded" ||
            warn "modprobe vboxdrv failed — reboot to finish VirtualBox setup"
    fi
else
    skip "VirtualBox setup (not installed)"
    ((SKIPPED++)) || true
fi

# Avahi
if pacman -Qi avahi &>/dev/null; then
    enable_service avahi-daemon.service
    if ! systemctl is-active avahi-daemon.service &>/dev/null; then
        sudo systemctl start avahi-daemon.service
        ok "avahi-daemon started"
    else
        skip "avahi-daemon (already running)"
        ((SKIPPED++)) || true
    fi
else
    skip "avahi-daemon (not installed)"
    ((SKIPPED++)) || true
fi

# Sunshine capabilities
if command -v sunshine &>/dev/null; then
    SUNSHINE_BIN="$(command -v sunshine)"
    if getcap "$SUNSHINE_BIN" 2>/dev/null | grep -q cap_sys_admin; then
        skip "Sunshine capabilities (already set)"
        ((SKIPPED++)) || true
    else
        sudo setcap cap_sys_admin+p "$SUNSHINE_BIN" &&
            ok "Sunshine capabilities set" ||
            warn "setcap failed — run manually after install"
        ((CONFIGURED++)) || true
    fi
else
    skip "Sunshine capabilities (not installed)"
    ((SKIPPED++)) || true
fi

# User directories
for dir in Projects Downloads "Pictures/Screenshots" Documents Videos Music; do
    if [[ -d "$HOME/$dir" ]]; then
        skip "~/$dir"
        ((SKIPPED++)) || true
    else
        mkdir -p "$HOME/$dir"
        ok "Created: ~/$dir"
        ((CONFIGURED++)) || true
    fi
done

# Notes vault
mkdir -p "$HOME/notes/journal"
if [[ ! -f "$HOME/notes/index.md" ]]; then
    cat >"$HOME/notes/index.md" <<'NOTESEOF'
# Notes

Welcome to your notes vault.
Open with `<leader>nn` in Neovim.
Create a journal entry with `<leader>nj`.
NOTESEOF
    ok "Notes index created"
    ((CONFIGURED++)) || true
else
    skip "~/notes/index.md (exists)"
    ((SKIPPED++)) || true
fi

# Set default apps via xdg-mime
if command -v xdg-mime &>/dev/null; then
    # imv as default image viewer
    xdg-mime default imv.desktop image/jpeg 2>/dev/null || true
    xdg-mime default imv.desktop image/png 2>/dev/null || true
    xdg-mime default imv.desktop image/gif 2>/dev/null || true
    xdg-mime default imv.desktop image/webp 2>/dev/null || true
    # mpv as default video player
    xdg-mime default mpv.desktop video/mp4 2>/dev/null || true
    xdg-mime default mpv.desktop video/mkv 2>/dev/null || true
    xdg-mime default mpv.desktop video/x-matroska 2>/dev/null || true
    # zathura as default PDF viewer
    xdg-mime default org.pwmt.zathura.desktop application/pdf 2>/dev/null || true
    ok "Default apps set (imv, mpv, zathura)"
else
    warn "xdg-utils not found — set default apps manually after login"
fi

# Wallpapers directory
mkdir -p "$HOME/.config/hypr/wallpapers"
if [[ -z "$(ls -A "$HOME/.config/hypr/wallpapers" 2>/dev/null)" ]]; then
    warn "No wallpaper found — add any .jpg/.png to ~/.config/hypr/wallpapers/ before rebooting"
fi

# ════════════════════════════════════════════════════════════════════
step "9 / 9  LazyVim"
# ════════════════════════════════════════════════════════════════════

if [[ -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]]; then
    skip "LazyVim (already bootstrapped)"
    ((SKIPPED++)) || true
else
    info "LazyVim installs automatically on first nvim launch (~2 min)."
fi

# ════════════════════════════════════════════════════════════════════
# Summary
# ════════════════════════════════════════════════════════════════════

echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║           HyprDots install complete!             ║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${GREEN}Installed :${RESET}  $INSTALLED  packages / tools"
echo -e "  ${CYAN}Configured:${RESET}  $CONFIGURED  files / services"
echo -e "  ${CYAN}Skipped   :${RESET}  $SKIPPED  already done"
echo ""
echo -e "${CYAN}${BOLD}Before rebooting:${RESET}"
echo -e "  1. Edit ${YELLOW}~/.gitconfig${RESET} — set your name + email"
echo -e "  2. Add a wallpaper → ${YELLOW}~/.config/hypr/wallpapers/${RESET}  (.jpg or .png)"
echo ""
echo -e "${CYAN}${BOLD}After reboot:${RESET}"
echo -e "  3. Ly login screen — session pre-set to ${YELLOW}hyprland${RESET}, just type password + Enter"
echo -e "  4. Open terminal → run ${YELLOW}nvim${RESET} once → LazyVim installs plugins (~2 min)"
echo -e "  5. Run ${YELLOW}nwg-look${RESET} → apply GTK dark theme + Papirus icons"
[[ -d "$BACKUP_DIR" ]] &&
    echo -e "  6. Old configs backed up to: ${YELLOW}$BACKUP_DIR${RESET}"
echo ""
echo -e "${CYAN}Ly controls:${RESET}  Tab/arrows = move  |  F1 = shutdown  |  F2 = reboot  |  Enter = login"
echo ""
