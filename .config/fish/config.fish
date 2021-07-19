source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish

set --global tide_pwd_truncate_margin 999
set --global tide_right_prompt_items status cmd_duration context jobs heroku rust virtual_env

fzf_configure_bindings --directory=\cf

direnv hook fish | source

# status is-login; and pyenv init --path | source
# pyenv init - | source
# status -i || exit  # see https://github.com/PatrickF1/fzf.fish/issues/183

# vim: et ts=2 sts=2 sw=2
