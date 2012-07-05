# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#juanghurtado zweizeilig
ZSH_THEME="wezm"

# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(django python git fabric osx brew pip)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
PATH=/usr/local/bin:/usr/local/share/python:$PATH
export PATH

export EDITOR="vim"

source /usr/local/bin/virtualenvwrapper.sh
export PROJECT_HOME=~/src/
#export PIP_REQUIRE_VIRTUALENV=true
export PIP_VIRTUALENV_BASE=$WORKON_HOME

alias cca="cctrlapp"
alias ccu="cctrluser"
