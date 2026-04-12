# ╔═══════════════════════════════════════╗
# ║               ~/.zshrc                ║
# ╚═══════════════════════════════════════╝

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ── Options ───────────────────────────────────────────────────────────────────
setopt AUTO_CD              # type dir name to cd into it
setopt CORRECT              # spell correction
setopt COMPLETE_IN_WORD
setopt GLOB_DOTS            # include dotfiles in glob

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins ───────────────────────────────────────────────────────────────────
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── Prompt (starship) ─────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"       # Rust
export PATH="$HOME/go/bin:$PATH"           # Go
export PATH="$HOME/.npm-global/bin:$PATH"  # npm global
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export ANDROID_HOME=/home/asf/Android/Sdk
# ── nvm (Node version manager) ────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ── pyenv (Python version manager) ───────────────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
fi

# ── Editor ────────────────────────────────────────────────────────────────────
export BAT_THEME="TwoDark"      # closest dark theme to Tokyo Night in bat
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# ── Wayland / XDG ─────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ── Man pages with color ──────────────────────────────────────────────────────
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ── Aliases — navigation ──────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ── Aliases — listing ────────────────────────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias tree='tree -C'

# ── Aliases — git ─────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias lg='lazygit'

# ── Aliases — docker ──────────────────────────────────────────────────────────
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias ld='lazydocker'

# ── Aliases — editors ─────────────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'
alias code='code --ozone-platform=wayland'   # VS Code native Wayland

# ── Aliases — system ──────────────────────────────────────────────────────────
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null && sudo pacman -Sc'
alias reload='source ~/.zshrc'
alias zshconfig='nvim ~/.zshrc'
alias hyprconfig='nvim ~/.config/hypr/hyprland.conf'

# ── Aliases — tools ───────────────────────────────────────────────────────────
# alias cat='bat --style=plain --paging=never 2>/dev/null || cat'
alias grep='grep --color=auto'
alias yazi='yazi'
alias y='yazi'
alias top='btop'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias ip='ip -color'

# ── Functions ─────────────────────────────────────────────────────────────────

# cd and list in one step
cdl() { cd "$@" && ll; }

# make dir and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# open yazi and cd to where you exit
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# git clone and cd
gcl() { git clone "$1" && cd "$(basename "$1" .git)"; }

# quick HTTP server in current dir
serve() { python -m http.server "${1:-8000}"; }

# extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"    ;;
            *.tar.gz)   tar xzf "$1"    ;;
            *.tar.xz)   tar xJf "$1"    ;;
            *.tar.zst)  tar --zstd -xf "$1" ;;
            *.bz2)      bunzip2 "$1"    ;;
            *.gz)       gunzip "$1"     ;;
            *.zip)      unzip "$1"      ;;
            *.7z)       7z x "$1"       ;;
            *.rar)      unrar x "$1"    ;;
            *.tar)      tar xf "$1"     ;;
            *)          echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# opencode
export PATH=/home/asf/.opencode/bin:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
