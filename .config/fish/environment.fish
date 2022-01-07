set --global -x EDITOR nvim
set --global -x PSQL_EDITOR nvim
set --global -x VISUAL nvim
set --global -x PAGER less
set --global -x LANG en_US.UTF-8
set --global -x LESS "-F -g -i -M -R -S -w -X -z-4"
set --global -x TMPDIR /private/tmp

set --global -x VIRTUAL_ENV_DISABLE_PROMPT true
set --global -x PIP_REQUIRE_VIRTUALENV true
set --global -x PIP_RESPECT_VIRTUALENV true

set --global -x XDG_CONFIG_HOME $HOME/.config/

set --global -x FD_OPTIONS "--hidden --follow --exclude .git"
set --global -x FZF_DEFAULT_OPTS "--no-hscroll --ansi --no-mouse --height 40% --layout=reverse --margin=0 --info=inline --preview-window=:noborder"

set --global -x FZF_DEFAULT_COMMAND "fd --type f --type l $FD_OPTIONS"
set --global -x FZF_CTRL_T_COMMAND "fd $FD_OPTIONS"
set --global -x FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS"

# configure memoize-script in ~/bin/runcached
set --global -x RUNCACHED_MAX_AGE 86400 # 1 day
set --global -x RUNCACHED_IGNORE_ENV 1
set --global -x RUNCACHED_IGNORE_PWD 1

# i do this myself in dotfiles/tasks.py
set --global -x HOMEBREW_NO_AUTO_UPDATE 1
set --global -x HOMEBREW_NO_INSTALL_CLEANUP 1

set --global -x FORGIT_LOG_GRAPH_ENABLE 1

# reuse / cache dependencies across rust projects
set --global -x RUSTC_WRAPPER sccache

set --global -x NVM_DIR "$HOME/.nvm"
set --global -x PYENV_ROOT "$HOME/.pyenv"

set --global -x _ZO_EXCLUDE_DIRS "$HOME:$HOME/.local/share/nvim"

# fix for neovim / virtualenv and direnv
# see https://vi.stackexchange.com/a/7644/
# if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
#   source "${VIRTUAL_ENV}/bin/activate"
# fi


# fisher / done
set -U __done_allow_nongraphical 1

fish_add_path $PYENV_ROOT/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path /usr/local/opt/curl/bin
