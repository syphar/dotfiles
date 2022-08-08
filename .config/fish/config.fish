source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish
source $XDG_CONFIG_HOME/fish/colors.fish

# has to be here, otherwise async-prompt doesn't work
starship init fish | source

# only delayed right prompt, left prompt should be immediate
set -U async_prompt_functions fish_right_prompt

# more exit codes to leave in the history
set sponge_successful_exit_codes 0 127 130

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

    # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
    complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
end

# vim: et ts=2 sts=2 sw=2
