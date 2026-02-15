# ============================================================
# Platform Detection
# ============================================================
_is_macos=false
_is_linux=false
_is_wsl=false

case "$(uname -s)" in
  Darwin) _is_macos=true ;;
  Linux)
    _is_linux=true
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
      _is_wsl=true
    fi
    ;;
esac

# ============================================================
# macOS Settings
# ============================================================
if $_is_macos; then
  # VIM_APP_DIR
  export VIM_APP_DIR=$HOME/Applications

  # Go setting
  if command -v go &> /dev/null; then
    export GOROOT=/usr/local/opt/go/libexec
    export GOPATH=$HOME/workspace/go
    export PATH=$GOROOT/bin:$PATH
    export PATH=$GOPATH/bin:$PATH
  fi

  # Homebrew
  eval $(/opt/homebrew/bin/brew shellenv)

  # rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

  # nodenv
  export PATH="$HOME/.nodenv/shims:${PATH}"
  export NODENV_SHELL=zsh
  command nodenv rehash 2>/dev/null
  nodenv() {
    local command
    command="${1:-}"
    if [ "$#" -gt 0 ]; then
      shift
    fi

    case "$command" in
    rehash|shell)
      eval "$(nodenv "sh-$command" "$@")";;
    *)
      command nodenv "$command" "$@";;
    esac
  }

  # Rancher Desktop
  export PATH="$HOME/.rd/bin:$PATH"
fi

# ============================================================
# Linux Settings (native Linux and WSL)
# ============================================================
if $_is_linux; then
  # Linuxbrew
  if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  fi
fi

# ============================================================
# WSL-specific Settings
# ============================================================
if $_is_wsl; then
  # SSH agent relay via npiperelay (Windows OpenSSH agent)
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  ss -a | grep -q "$SSH_AUTH_SOCK"
  if [ $? -ne 0 ]; then
    rm -f "$SSH_AUTH_SOCK"
    (setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:"/mnt/c/tools/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
  fi
fi

# ============================================================
# Global Settings
# ============================================================
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -e

# Completion
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

# Sheldon (plugin manager)
eval "$(sheldon source)"

# Locale
export LC_CTYPE=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# Editor
export EDITOR='vim'

# ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# FZF
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'

## fzf history search
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

# ============================================================
# Aliases - Common
# ============================================================
alias la='ls -la'
alias ll='ls -l'
alias today='date +"%Y-%m-%d"'

## Git
alias g='git'
alias gb='git branch'
alias gco='git checkout'
alias gf='git fetch'
alias git_branch_name="git branch | grep \* | cut -d ' ' -f2"
alias ggpush='git push origin $(git_branch_name)'
alias gl='git pull'
alias gp='git push'
alias gst='git status'
alias gwip='git add -A; git rm --cached $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'

# GHQ
alias repos='ghq list -p | fzf'
alias repo='cd $(repos)'

# ============================================================
# Aliases - WSL-specific
# ============================================================
if $_is_wsl; then
  alias open='explorer.exe'
  alias win_paste='powershell.exe Get-Clipboard'
fi


# ============================================================
# Cross-platform tool integrations
# ============================================================
# direnv
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi
