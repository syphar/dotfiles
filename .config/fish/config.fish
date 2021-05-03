source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish

set --universal tide_pwd_truncate_margin 999
set --universal -x tide_right_prompt_items status cmd_duration context jobs heroku virtual_env

direnv hook fish | source

# vim: et ts=2 sts=2 sw=2
