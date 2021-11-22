source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish

fzf_configure_bindings --directory=\cf

/usr/local/bin/direnv hook fish | source
/usr/local/bin/starship init fish | source

# status is-login; and pyenv init --path | source
# pyenv init - | source
# status -i || exit  # see https://github.com/PatrickF1/fzf.fish/issues/183

# vim: et ts=2 sts=2 sw=2
