ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dcn"

alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
BAT_CHARGE="$HOME/src/dotfiles/batcharge.py"

PATH=/usr/local/sbin:/usr/local/bin:/usr/local/share/python:$PATH
export PATH

plugins=(
    brew 
    dircycle 
    django
    fabric 
    gem 
    git 
    history-substring-search 
    knife 
    last-working-dir 
    mercurial 
    mvn 
    osx 
    per-directory-history 
    pip 
    python 
    svn
    virtualenvwrapper
)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export EDITOR="vim"

#export PROJECT_HOME=~/src/
export VIRTUAL_ENV_DISABLE_PROMPT=true
export PIP_REQUIRE_VIRTUALENV=true
export PIP_VIRTUALENV_BASE=$WORKON_HOME

alias cca="export CCTRL_API_URL=https://api.devcctrl.com && export SSH_FORWARDER=sshdevcctrl.cloudcontrolled.net && export CCTRL_TOKEN_FILE=dev.json && /usr/local/share/python/cctrlapp"
alias lcca="export CCTRL_API_URL=http://localhost:8000 && export CCTRL_TOKEN_FILE=local.json && /usr/local/share/python/cctrlapp"
alias cctrlapp="export CCTRL_API_URL=https://api.cloudcontrol.com && export SSH_FORWARDER=ssh.cloudcontrolled.net && export CCTRL_TOKEN_FILE=live.json && /usr/local/share/python/cctrlapp"

alias ccu="export CCTRL_API_URL=https://api.devcctrl.com && export SSH_FORWARDER=sshdevcctrl.cloudcontrolled.net && export CCTRL_TOKEN_FILE=dev.json && /usr/local/share/python/cctrluser"
alias lccu="export CCTRL_API_URL=http://localhost:8000 && export CCTRL_TOKEN_FILE=local.json && /usr/local/share/python/cctrluser"
alias cctrluser="export CCTRL_API_URL=https://api.cloudcontrol.com && export SSH_FORWARDER=ssh.cloudcontrolled.net && export CCTRL_TOKEN_FILE=live.json && /usr/local/share/python/cctrluser"

alias gur="git fetch --all --recurse-submodules=yes --prune && git fetch --all --recurse-submodules=yes --prune"

alias pipupgrade="pip freeze | grep = | cut -d = -f 1 | xargs pip install -U"

export BYOBU_PREFIX=$(brew --prefix)
export NODE_PATH=/usr/local/lib/node_modules
