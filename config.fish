set -x LC_CTYPE ja_JP.UTF-8

## rbenv setting
set -x PATH /Users/satotoru/.rbenv/shims $PATH

## pyenv
set -x PYENV_ROOT $HOME/.pyenv
set -x PATH $PYENV_ROOT/shims $PATH
status --is-interactive; and source (pyenv init -|psub)

## nodebrew
set -x PATH $HOME/.nodebrew/current/bin $PATH

## editor setting
set -x EDITOR 'vim'
set -x VIM_APP_DIR $HOME/Applications

## go setting
set -x GOROOT /usr/local/opt/go/libexec
set -x GOPATH $HOME/workspace/go
set -x PATH $GOROOT/bin $PATH
set -x PATH $GOPATH/bin $PATH

## Java setting
set -x JAVA_HOME ( /usr/libexec/java_home -v "1.8" )
set -x PATH $JAVA_HOME/bin $PATH

## Android setting
set -x ANDROID_HOME /Users/satotoru/Library/Android/sdk
set -x PATH ~/Library/Android/sdk/platform-tools $PATH

## postgres setting
set -x PGDATA /usr/local/var/postgres

# hub setting
function git
  hub $argv
end

# alias
## common
alias be 'bundle exec'
## git
alias g 'git'
alias gb 'git branch'
alias gco 'git checkout'
alias gf 'git fetch'
alias ggpush 'git push origin (git_branch_name)'
alias gl 'git pull'
alias gp 'git push'
alias gst 'git status'
alias gwip 'git add -A; git rm (git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'
alias clear '/usr/bin/clear'
