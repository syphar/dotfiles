source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish
source $XDG_CONFIG_HOME/fish/colors.fish

fzf_configure_bindings --directory=\cf

# configure franciscolourenco/done
set -U __done_allow_nongraphical 1
set -U __done_exclude 'nvim|vim'

/usr/local/bin/direnv hook fish | source

# /usr/local/bin/starship init fish | source
~/src/starship/target/release/starship init fish | source

/usr/local/bin/zoxide init fish --cmd cd | source

# vim: et ts=2 sts=2 sw=2
