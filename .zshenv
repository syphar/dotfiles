#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='nvim'
export PSQL_EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

#
# Language
#

export LANG='en_US.UTF-8'

#
# Paths
#

typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi


#
# Temporary Files
#
export TMPDIR="/private/tmp"

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi


# virtualenv / -wrapper
export PROJECT_HOME="$HOME/src"
export WORKON_HOME="$HOME/.virtualenvs"
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export VIRTUAL_ENV_DISABLE_PROMPT=true
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
export PIP_VIRTUALENV_BASE=$WORKON_HOME

export PATH=/usr/local/lib/ruby/gems/2.6.0/bin:$PATH:~/.local/bin:~/bin/:

export FD_OPTIONS="--hidden --follow"
export FZF_DEFAULT_OPTS="--no-hscroll --no-mouse --height 40% --layout=reverse --margin=0 --info=inline --preview-window=:noborder"

export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"


# configure memoize-script in ~/bin/runcached
export RUNCACHED_MAX_AGE=86400  # 1 day
export RUNCACHED_IGNORE_ENV=1
export RUNCACHED_IGNORE_PWD=1

# for working vi-mode
export KEYTIMEOUT=1

# i do this myself in dotfiles/tasks.py
export HOMEBREW_NO_AUTO_UPDATE=1

# reuse / cache dependencies across rust projects
export RUSTC_WRAPPER=sccache
# export SCCACHE_CACHE_SIZE=10G
# export SCCACHE_DIR=~/.cache/rust/sccache



export NVM_DIR="$HOME/.nvm"
export BC_CACHE_DIR="$HOME/.cache/bc"

export CLICOLOR=1

# export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
# export CPPFLAGS=-I/usr/local/opt/openssl/include
# export LDFLAGS=-L/usr/local/opt/openssl/lib


# mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

# fix for neovim / virtualenv and direnv
# see https://vi.stackexchange.com/a/7644/
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

# vim: et ts=2 sts=2 sw=2
