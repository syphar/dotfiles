set --global -x XDG_CONFIG_HOME $HOME/.config/

source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish
source $XDG_CONFIG_HOME/fish/colors.fish

# before starship/zoxide, which are installed via mise
mise activate fish | source

# has to be here, otherwise async-prompt doesn't work
starship init fish | source

# only delayed right prompt, left prompt should be immediate
# set -U async_prompt_functions fish_right_prompt

# show loading indicator
# function fish_right_prompt_loading_indicator
#     echo (set_color '#aaa')' … '(set_color normal)
# end

# hide greeting
set -U fish_greeting

# configure franciscolourenco/done
set -U __done_allow_nongraphical 1
set -U __done_exclude 'nvim|vim'

if status --is-interactive
    if test (string split -f1 . $version) -ge 4
        fzf_configure_bindings --directory=\cf
    else
        # shortcut: fish 3 doesn't know fzf.fish's "ctrl-r" key names; drop once the server has fish 4
        fzf_configure_bindings --directory=\cf --git_log=\e\cl --git_status=\e\cs \
            --history=\cr --processes=\e\cp --variables=\cv
    end

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
