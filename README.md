# HyprDots

Personal Hyprland dotfiles — Tokyo Night · Intel iGPU · Full-stack dev

## Stack

| Component     | App                    |
|---------------|------------------------|
| Display Manager | Ly (TUI)             |
| WM            | Hyprland               |
| Bar           | Waybar                 |
| Launcher      | Rofi-wayland           |
| Notifications | Dunst                  |
| Lock / Idle   | Hyprlock + Hypridle    |
| Wallpaper     | swww                   |
| Terminal      | Kitty                  |
| Shell         | Zsh + Starship         |
| Editor        | Neovim (LazyVim)       |
| GUI Editor    | VS Code                |
| Files (GUI)   | Thunar                 |
| Files (TUI)   | Yazi                   |
| PDF           | Zathura                |
| Office        | LibreOffice Fresh      |
| VM            | VirtualBox             |
| Streaming     | Sunshine               |
| Theme         | Tokyo Night everywhere |

## Install

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

## Structure

```
dotfiles/
├── install.sh                  ← run this
├── .config/
│   ├── ly/
│   │   └── config.ini          ← Ly DM (username auto-filled by install.sh)
│   ├── hypr/
│   │   ├── hyprland.conf       ← entry point, sources all below
│   │   ├── hyprlock.conf
│   │   ├── hypridle.conf
│   │   ├── themes/
│   │   │   └── colors.conf     ← Tokyo Night palette (edit to retheme)
│   │   ├── conf/
│   │   │   ├── monitor.conf    ← resolution / refresh rate
│   │   │   ├── input.conf      ← keyboard / touchpad
│   │   │   ├── keybinds.conf   ← all keybinds
│   │   │   ├── autostart.conf  ← startup apps
│   │   │   └── rules.conf      ← window rules
│   │   ├── scripts/
│   │   │   ├── wallpaper.sh
│   │   │   ├── volume.sh
│   │   │   └── powermenu.sh
│   │   └── wallpapers/         ← drop .jpg/.png files here
│   ├── waybar/
│   │   ├── config.jsonc
│   │   └── style.css
│   ├── rofi/
│   │   ├── config.rasi
│   │   └── theme.rasi
│   ├── dunst/dunstrc
│   ├── kitty/kitty.conf
│   ├── zathura/zathurarc
│   ├── nvim/
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── options.lua
│   │       │   ├── keymaps.lua
│   │       │   └── autocmds.lua
│   │       └── plugins/
│   │           └── extras.lua
│   ├── starship/starship.toml
│   ├── gtk-3.0/settings.ini
│   ├── gtk-4.0/settings.ini
│   └── Code/User/settings.json
└── home/
    ├── .zshrc
    └── .gitconfig              ← edit name/email after install
```

## Key bindings

| Bind             | Action                      |
|------------------|-----------------------------|
| SUPER + Return   | Terminal (kitty)            |
| SUPER + D        | App launcher (rofi)         |
| SUPER + E        | File manager (thunar)       |
| SUPER + B        | Browser (firefox)           |
| SUPER + N        | Neovim                      |
| SUPER + Q        | Close window                |
| SUPER + F        | Fullscreen                  |
| SUPER + T        | Toggle floating             |
| SUPER + V        | Clipboard history           |
| SUPER + H/J/K/L  | Move focus (vim keys)       |
| SUPER+SHIFT+H/L  | Move window                 |
| SUPER + 1-9      | Switch workspace            |
| SUPER+SHIFT+1-9  | Move window to workspace    |
| SUPER+SHIFT+E    | Power menu                  |
| SUPER+SHIFT+R    | Reload Hyprland             |
| Print            | Screenshot area             |
| SHIFT+Print      | Screenshot fullscreen       |

## After install checklist

1. Edit `~/.gitconfig` — add your name and email
2. Drop a wallpaper in `~/.config/hypr/wallpapers/`
3. Reboot (docker + vboxusers groups need a re-login)
4. Log into TTY and type `Hyprland`
5. Run `nvim` once to bootstrap LazyVim plugins
6. Run `nwg-look` to apply GTK dark theme
7. Install VS Code extensions: Tokyo Night theme, Prettier, language packs
