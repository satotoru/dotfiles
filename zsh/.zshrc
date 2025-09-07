# Mac Settings
if [[ $(uname -a | grep -c Darwin) -gt 0 ]]; then
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

# WSL Settings
if [[ $(uname -a | grep -c microsoft) -gt 0 ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

  # Cargo (Rust) settings
  if command -v cargo &> /dev/null; then
    export PATH='/home/satotoru/.cargo/bin':$PATH
  fi

  # Haskell settings
  if [[ -z $GHCUP_INSTALL_BASE_PREFIX[1] ]]; then
    export GHCUP_INSTALL_BASE_PREFIX=$HOME
  fi
  export PATH=$HOME/.cabal/bin:$PATH
  export PATH=/home/satotoru/.ghcup/bin:$PATH

  # ssh-agentを起動
  keychain -q --nogui $HOME/.ssh/id_rsa
  source $HOME/.keychain/$(hostname)-sh
fi

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -e

# The following lines were added by compinstall
zstyle :compinstall filename '/home/satotoru/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(sheldon source)"

# Set locale settings
export LC_CTYPE=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# Editor setting
export EDITOR='vim'

# FZF setting
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'

## fzf
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

# Aliases
## Common
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
alias start_dev_instance='aws ec2 start-instances --instance-ids $(aws ec2 describe-instances --filters "Name=tag-key,Values=Name" "Name=tag-value,Values=dev_home" --query "Reservations[*].Instances[*].[InstanceId]" --output text)'
alias stop_dev_instance='aws ec2 stop-instances --instance-ids $(aws ec2 describe-instances --filters "Name=tag-key,Values=Name" "Name=tag-value,Values=dev_home" --query "Reservations[*].Instances[*].[InstanceId]" --output text)'

# WSL only alias
if [[ $(uname -a | grep -c microsoft) -gt 0 ]]; then
  alias open='explorer.exe'
  alias win_paste='powershell.exe Get-Clipboard'

  if [ -e /home/satotoru/.nix-profile/etc/profile.d/nix.sh ]; then . /home/satotoru/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
fi

# Mac only
if [[ $(uname -a | grep -c Darwin) -gt 0 ]]; then
  # direnv
  eval "$(direnv hook zsh)"
fi
