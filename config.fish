set -x LC_CTYPE ja_JP.UTF-8
set -x LC_ALL ja_JP.UTF-8

## editor setting
set -x EDITOR 'vim'
set -x VIM_APP_DIR $HOME/Applications


## Mac Settings
if [ (uname -a | grep Darwin | wc -l) -gt 0 ]
  ## go setting
  if [ (which go |  wc -l) -gt 0 ]
    set -x GOROOT /usr/local/opt/go/libexec
    set -x GOPATH $HOME/workspace/go
    set -x PATH $GOROOT/bin $PATH
    set -x PATH $GOPATH/bin $PATH
  end
  ## openssl setting
  set -x PATH '/usr/local/opt/openssl/bin' $PATH
  # python settings
  if [ (which python |  wc -l) -gt 0 ]
    set -x PATH '/Users/satotoru/Library/Python/3.7/bin' $PATH
  end
end

# fzf setting
set -x FZF_DEFAULT_COMMAND 'ag --nocolor -g ""'

# alias
## common
alias be 'bundle exec'
alias today 'date +"%Y-%m-%d"'
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
alias gfzco 'git branch | fzf | xargs -I\'{}\' git checkout \'{}\''
alias clear '/usr/bin/clear'
# docker
alias dki 'docker container run --rm -i -t -P'
alias dkd 'docker container run -d -P'
alias dex "docker container exec -i -t"
alias dc "docker-compose"
alias dce "docker-compose exec"
alias dcr "docker-compose run"
# ghq
alias repos 'ghq list -p | fzf'
alias repo 'cd (repos)'

# WSL only alias
if [ (uname -a | grep microsoft | wc -l) -gt 0 ]
  alias open 'explorer.exe'
end
