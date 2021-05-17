source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish

set --universal tide_pwd_truncate_margin 999
set --universal tide_right_prompt_items status cmd_duration context jobs heroku virtual_env

direnv hook fish | source

# status is-login; and pyenv init --path | source
# pyenv init - | source

# vim: et ts=2 sts=2 sw=2
