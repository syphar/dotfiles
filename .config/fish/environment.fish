set --universal -x EDITOR nvim
set --universal -x PSQL_EDITOR nvim
set --universal -x VISUAL nvim
set --universal -x PAGER less
set --universal -x LANG en_US.UTF-8
set --universal -x LESS "-F -g -i -M -R -S -w -X -z-4"
set --universal -x TMPDIR "/private/tmp"

set --universal -x VIRTUAL_ENV_DISABLE_PROMPT true
set --universal -x PIP_REQUIRE_VIRTUALENV true
set --universal -x PIP_RESPECT_VIRTUALENV true

set --universal -x XDG_CONFIG_HOME $HOME/.config/

set --universal -x FD_OPTIONS "--hidden --follow --exclude .git"
set --universal -x FZF_DEFAULT_OPTS "--no-hscroll --no-mouse --height 40% --layout=reverse --margin=0 --info=inline --preview-window=:noborder"

set --universal -x FZF_DEFAULT_COMMAND "fd --type f --type l $FD_OPTIONS"
set --universal -x FZF_CTRL_T_COMMAND "fd $FD_OPTIONS"
set --universal -x FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS"

# configure memoize-script in ~/bin/runcached
set --universal -x RUNCACHED_MAX_AGE 86400  # 1 day
set --universal -x RUNCACHED_IGNORE_ENV 1
set --universal -x RUNCACHED_IGNORE_PWD 1

# i do this myself in dotfiles/tasks.py
set --universal -x HOMEBREW_NO_AUTO_UPDATE 1

# reuse / cache dependencies across rust projects
set --universal -x RUSTC_WRAPPER sccache

set --universal -x NVM_DIR "$HOME/.nvm"

# fix for neovim / virtualenv and direnv
# see https://vi.stackexchange.com/a/7644/
# if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
#   source "${VIRTUAL_ENV}/bin/activate"
# fi
#

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
