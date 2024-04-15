source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish
source $XDG_CONFIG_HOME/fish/colors.fish

# has to be here, otherwise async-prompt doesn't work
starship init fish | source

# only delayed right prompt, left prompt should be immediate
set -U async_prompt_functions fish_right_prompt

# show loading indicator
function fish_right_prompt_loading_indicator
    echo (set_color '#aaa')' … '(set_color normal)
end

# configure franciscolourenco/done
set -U __done_allow_nongraphical 1
set -U __done_exclude 'nvim|vim'

if status --is-interactive
    fzf_configure_bindings --directory=\cf

    direnv hook fish | source

    zoxide init fish --cmd cd | source

    # upgrade open-file limit for vim & docs.rs
    ulimit -n 10000

    # autostart or autoattach tmux when not inside tmux
    # if not set -q TMUX
    #     tmux attach -t base || tmux new -s base
    #     # FIXME: the command should replace the shell, like this the shell remains when tmux was quit
    # end
end

# vim: et ts=4 sts=4 sw=4
