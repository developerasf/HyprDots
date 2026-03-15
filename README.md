<div align="center">

# HyprDots

**A clean, modular Hyprland dotfiles setup**
Tokyo Night · Intel iGPU · Full-stack Dev

![Hyprland](https://img.shields.io/badge/Hyprland-0.45%2B-blue?style=flat-square&logo=wayland)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-rolling-1793D1?style=flat-square&logo=arch-linux)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

</div>

---

## Stack

| Category | App |
|---|---|
| **OS** | Arch Linux |
| **Display Manager** | Ly (TUI) |
| **Window Manager** | Hyprland (Wayland) |
| **Status Bar** | Waybar |
| **App Launcher** | Rofi-wayland |
| **Notifications** | Dunst |
| **Lock Screen** | Hyprlock |
| **Idle Daemon** | Hypridle |
| **Wallpaper** | swww |
| **Terminal** | Kitty |
| **Shell** | Zsh + Starship prompt |
| **Editor (TUI)** | Neovim + LazyVim |
| **Editor (GUI)** | VS Code |
| **File Manager (GUI)** | Thunar |
| **File Manager (TUI)** | Yazi |
| **PDF Viewer** | Zathura |
| **Video Player** | mpv |
| **Image Viewer** | imv |
| **Office Suite** | LibreOffice Fresh |
| **VM** | Oracle VirtualBox |
| **Game Streaming** | Sunshine (Moonlight host) |
| **Theme** | Tokyo Night (system-wide) |
| **Icons** | Papirus Dark |
| **Font** | JetBrainsMono Nerd Font |

---

## Before You Start

This dotfiles setup is designed for **Arch Linux only**. Before running
the install script, your system needs:

| Requirement | Why |
|---|---|
| Arch Linux installed | Script uses `pacman` and AUR |
| A normal user account (not root) | Script refuses to run as root |
| User in `wheel` group with sudo | Needs `sudo` for system changes |
| `base-devel` installed | Required to build AUR packages |
| `git` and `curl` installed | Needed before yay and nvm |
| Active internet connection | Downloads ~2GB of packages |
| Intel iGPU | Configs tuned for Intel VA-API |

### Minimal packages needed on a fresh Arch install

When using `archinstall`, make sure these are selected:

```
base  base-devel  linux  linux-firmware
networkmanager  sudo  git  curl
```

After first boot, enable networking:

```bash
sudo systemctl enable --now NetworkManager
```

---

## Installation

> You only need **one file**: `dotfiles.tar.gz`
> Everything else is inside it.

```bash
# 1. Download dotfiles.tar.gz

# 2. Extract
tar -xzf dotfiles.tar.gz

# 3. Run the installer
cd dotfiles
bash install.sh
```

The script is fully automated. It will:

- Install `yay` (AUR helper) if not present
- Install all 60+ packages from pacman and AUR
- Install `nvm`, `pyenv`, and `rustup` via curl
- Symlink all configs to `~/.config/` (backs up existing files)
- Enable services: Docker, Ly, Avahi, VirtualBox
- Set zsh as your default shell
- Add you to `docker` and `vboxusers` groups
- Set `imv`, `mpv`, `zathura` as default apps via xdg-mime
- Configure the Ly display manager with your username

**Safe to re-run** — every step checks if already done and skips it.

---

## What Gets Installed

### Hyprland ecosystem
`hyprland` `xdg-desktop-portal-hyprland` `waybar` `dunst` `rofi-wayland`
`hyprlock` `hypridle` `swww` `polkit-kde-agent`

### Terminal & shell
`kitty` `zsh` `starship` `zsh-autosuggestions` `zsh-syntax-highlighting`

### Editors & dev tools
`neovim` `lazygit` `lazydocker` `github-cli` `ripgrep` `fd` `bat` `git-delta`
`visual-studio-code-bin`

### Docker & containers
`docker` `docker-compose`

### Language toolchains
`nodejs` `npm` `pnpm` `typescript` — via nvm
`python` `python-pip` `python-virtualenv` — via pyenv
`rust` `cargo` — via rustup
`go` `gcc` `gdb` `jdk-openjdk`

### Files & media
`thunar` `yazi` `mpv` `imv` `zathura` `firefox`

### System utilities
`pipewire` `wireplumber` `pipewire-pulse` `pavucontrol`
`brightnessctl` `playerctl` `cliphist` `wl-clipboard`
`htop` `btop` `man-db` `p7zip` `unzip` `unarchiver`

### VM & streaming
`virtualbox` `virtualbox-host-modules-arch` `sunshine-bin` `avahi`

### Office & docs
`libreoffice-fresh` `pandoc-bin`

### Theming
`catppuccin-gtk-theme-mocha` `papirus-icon-theme`
`ttf-jetbrains-mono-nerd` `ttf-font-awesome`
`noto-fonts` `noto-fonts-emoji` `nwg-look`
`gtk-3.0` and `gtk-4.0` dark mode settings

### Display manager
`ly` (TUI display manager — replaces SDDM/GDM)

---

## After Install Checklist

Do these steps after the script finishes:

**Before rebooting:**
```bash
# 1. Set your git identity
nano ~/.gitconfig
# Change "Your Name" and "you@example.com"

# 2. Add a wallpaper
cp your-wallpaper.jpg ~/.config/hypr/wallpapers/
# Supports .jpg and .png — name it anything
```

**After reboot:**

| Step | Command / Action |
|---|---|
| Ly login | Type password and press Enter (session pre-set to Hyprland) |
| Bootstrap Neovim | Run `nvim` — wait ~2 min for LazyVim to install plugins |
| Apply GTK theme | Run `nwg-look` → set Adwaita-dark + Papirus-Dark + Adwaita cursor |
| GitHub CLI | Run `gh auth login` |
| Sunshine | Open `https://localhost:47990` to configure game streaming |
| LibreOffice dark | Tools → Options → LibreOffice → View → Application colors → Dark |

---

## Folder Structure

```
dotfiles/
├── install.sh                      ← run this — installs everything
│
├── .config/
│   │
│   ├── hypr/                       ← Hyprland (all WM config lives here)
│   │   ├── hyprland.conf           ← entry point, sources all modules below
│   │   ├── hyprlock.conf           ← lock screen layout and colors
│   │   ├── hypridle.conf           ← idle timeouts (dim → lock → suspend)
│   │   │
│   │   ├── themes/
│   │   │   └── colors.conf         ← Tokyo Night palette — edit to retheme
│   │   │
│   │   ├── conf/                   ← one concern per file
│   │   │   ├── monitor.conf        ← resolution, refresh rate, scale
│   │   │   ├── input.conf          ← keyboard layout, mouse, touchpad
│   │   │   ├── keybinds.conf       ← all SUPER key bindings
│   │   │   ├── autostart.conf      ← apps launched on login
│   │   │   └── rules.conf          ← window float/workspace/opacity rules
│   │   │
│   │   ├── scripts/
│   │   │   ├── wallpaper.sh        ← random wallpaper picker (swww)
│   │   │   ├── volume.sh           ← volume keys with notification
│   │   │   ├── brightness.sh       ← brightness keys with notification
│   │   │   ├── screenshot.sh       ← area/window/screen capture (grimblast)
│   │   │   ├── powermenu.sh        ← rofi power menu (lock/suspend/reboot/off)
│   │   │   └── tty-colors.sh       ← Tokyo Night colors for TTY/Ly
│   │   │
│   │   └── wallpapers/             ← drop your .jpg or .png files here
│   │
│   ├── waybar/
│   │   ├── config.jsonc            ← modules: workspaces, clock, cpu, memory...
│   │   └── style.css               ← Tokyo Night styling
│   │
│   ├── rofi/
│   │   ├── config.rasi             ← rofi settings and mode config
│   │   └── theme.rasi              ← Tokyo Night theme
│   │
│   ├── dunst/
│   │   └── dunstrc                 ← notification appearance and behavior
│   │
│   ├── kitty/
│   │   └── kitty.conf              ← font, colors, opacity, keybinds
│   │
│   ├── nvim/                       ← LazyVim configuration
│   │   ├── init.lua                ← bootstrap + lazy.nvim setup
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── options.lua     ← editor settings (tabs, numbers, etc.)
│   │       │   ├── keymaps.lua     ← custom key mappings
│   │       │   └── autocmds.lua    ← automatic commands on events
│   │       └── plugins/
│   │           └── extras.lua      ← extra plugins (tokyonight, harpoon, etc.)
│   │
│   ├── lazygit/
│   │   └── config.yml              ← Tokyo Night theme, delta pager, keybinds
│   │
│   ├── mpv/
│   │   ├── mpv.conf                ← Intel VA-API, Wayland, pipewire audio
│   │   └── input.conf              ← vim-style keybinds
│   │
│   ├── yazi/
│   │   ├── yazi.toml               ← file manager config and openers
│   │   ├── keymap.toml             ← vim-style navigation keybinds
│   │   └── theme.toml              ← Tokyo Night colors and file icons
│   │
│   ├── zathura/
│   │   └── zathurarc               ← dark mode PDF viewer, vim keybinds
│   │
│   ├── btop/
│   │   └── btop.conf               ← system monitor, vim keys, Tokyo Night
│   │
│   ├── starship/
│   │   └── starship.toml           ← prompt: git, python, rust, go, node icons
│   │
│   ├── ly/
│   │   └── config.ini              ← display manager (username auto-filled)
│   │
│   ├── gtk-3.0/settings.ini        ← dark mode for all GTK3 apps
│   ├── gtk-4.0/settings.ini        ← dark mode for all GTK4 apps
│   ├── environment.d/
│   │   └── hyprland.conf           ← Wayland env vars for all user services
│   ├── docker/
│   │   └── daemon.json             ← Docker logging and storage settings
│   └── Code/User/
│       └── settings.json           ← VS Code: Tokyo Night, JetBrains font
│
└── home/
    ├── .zshrc                      ← aliases, PATH, nvm/pyenv/cargo, functions
    ├── .zprofile                   ← XDG vars, startw fallback function
    ├── .gitconfig                  ← delta pager, aliases, colors
    └── .editorconfig               ← consistent indent style across all editors
```

---

## Keybindings

### Applications
| Keybind | Action |
|---|---|
| `SUPER + Return` | Terminal (Kitty) |
| `SUPER + D` | App launcher (Rofi) |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + B` | Browser (Firefox) |
| `SUPER + N` | Neovim |
| `SUPER + SHIFT + E` | Power menu (lock / suspend / reboot / shutdown) |
| `SUPER + V` | Clipboard history picker |

### Windows
| Keybind | Action |
|---|---|
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + SHIFT + F` | Maximize (no fullscreen signal to app) |
| `SUPER + T` | Toggle floating |
| `SUPER + P` | Toggle pseudotile |
| `SUPER + J` | Toggle split direction |

### Focus & movement
| Keybind | Action |
|---|---|
| `SUPER + H/J/K/L` | Move focus (vim keys) |
| `SUPER + Arrow keys` | Move focus |
| `SUPER + SHIFT + H/J/K/L` | Move window |
| `SUPER + ALT + H/J/K/L` | Resize window |

### Workspaces
| Keybind | Action |
|---|---|
| `SUPER + 1–9` | Switch to workspace |
| `SUPER + SHIFT + 1–9` | Move window to workspace |
| `SUPER + Tab` | Next workspace |
| `SUPER + SHIFT + Tab` | Previous workspace |
| `SUPER + Scroll` | Cycle workspaces |

### Screenshots
| Keybind | Action |
|---|---|
| `Print` | Screenshot area (copy + save) |
| `SHIFT + Print` | Screenshot fullscreen |
| `SUPER + Print` | Screenshot active window |

### Media & brightness
| Keybind | Action |
|---|---|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioNext/Prev` | Next/previous track |
| `XF86MonBrightnessUp/Down` | Brightness up/down |

### System
| Keybind | Action |
|---|---|
| `SUPER + SHIFT + R` | Reload Hyprland config |
| `SUPER + SHIFT + Q` | Exit Hyprland |
| `SUPER + mouse drag` | Move window |
| `SUPER + right mouse drag` | Resize window |

---

## Workspace Layout

Windows are auto-assigned to workspaces:

| Workspace | App |
|---|---|
| 1 | Terminal (Kitty) |
| 2 | Browser (Firefox) |
| 3 | Code (VS Code / Neovim) |
| 4 | Files (Thunar / Zathura) |
| 5 | VirtualBox |

---

## Customization

### Change the color scheme
Edit `~/.config/hypr/themes/colors.conf` — this is the single source of truth
for all Hyprland colors. Waybar and Rofi have their own CSS/rasi theme files
to update separately.

### Change monitor resolution
Edit `~/.config/hypr/conf/monitor.conf`:
```
monitor = , 1920x1080@60, 0x0, 1
# Format: monitor = name, resolution@hz, position, scale
# Run: hyprctl monitors  to find your monitor name
```

### Change keyboard layout
Edit `~/.config/hypr/conf/input.conf`:
```ini
input {
    kb_layout = us   # change to your layout code
}
```

### Add a new keybind
Edit `~/.config/hypr/conf/keybinds.conf`:
```ini
bind = SUPER, G, exec, your-app
```
Then reload: `SUPER + SHIFT + R`

### Add autostart apps
Edit `~/.config/hypr/conf/autostart.conf`:
```ini
exec-once = your-app
```

---

## Troubleshooting

### Hyprland won't start
```bash
# Check the log
cat ~/.local/share/hyprland/hyprland.log | grep -i error

# Test config syntax
Hyprland --config ~/.config/hypr/hyprland.conf --check
```

### Black screen after Ly login
```bash
# Switch to another TTY
Ctrl+Alt+F3

# Check log
cat ~/.local/share/hyprland/hyprland.log

# Try launching manually
Hyprland
```

### No wallpaper showing
```bash
# Make sure swww-daemon is running
pgrep swww-daemon || swww-daemon

# Set wallpaper manually
swww img ~/.config/hypr/wallpapers/your-wallpaper.jpg
```

### Waybar not showing
```bash
# Check for config errors
waybar --log-level debug 2>&1 | head -30

# Restart manually
killall waybar; waybar &
```

### Audio not working
```bash
# Check pipewire
systemctl --user status pipewire pipewire-pulse wireplumber

# Restart audio stack
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Screen not locking
```bash
# Check hypridle
systemctl --user status hypridle

# Test hyprlock manually
hyprlock
```

### VirtualBox kernel module error
```bash
# Load the module
sudo modprobe vboxdrv

# If that fails, reboot — the module loads on boot after install
sudo reboot
```

### Neovim plugins not installing
```bash
# Open nvim and run
nvim
# Then inside nvim:
:Lazy sync
```

### Can't use Docker without sudo
```bash
# You need to re-login after install for group to activate
# Check you're in the docker group
groups $USER | grep docker

# If not:
sudo usermod -aG docker $USER
# Then re-login
```

---

## Manual Steps After Install

These cannot be automated — do them once after first login:

```bash
# 1. Set your git identity
nano ~/.gitconfig
# Set: name = Your Name
# Set: email = you@example.com

# 2. Apply GTK theme
nwg-look
# Select: Adwaita-dark (theme) + Papirus-Dark (icons) + Adwaita (cursor)

# 3. Bootstrap Neovim plugins
nvim
# Wait ~2 minutes for LazyVim to install everything, then :q

# 4. Authenticate GitHub CLI (optional)
gh auth login

# 5. Configure Sunshine (optional)
# Open browser: https://localhost:47990

# 6. Enable LibreOffice dark mode (optional)
# Tools → Options → LibreOffice → View → Application colors → Dark mode
```

---

## Credits

- [Hyprland](https://hyprland.org) — Wayland compositor
- [LazyVim](https://lazyvim.org) — Neovim config framework
- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) — color scheme
- [Catppuccin](https://catppuccin.com) — GTK theme
- [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) — icon theme

---

<div align="center">
Made for Arch Linux · Hyprland · Tokyo Night
</div>
