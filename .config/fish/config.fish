source $XDG_CONFIG_HOME/fish/aliases.fish
source $XDG_CONFIG_HOME/fish/key_bindings.fish
source $XDG_CONFIG_HOME/fish/environment.fish
source $XDG_CONFIG_HOME/fish/colors.fish


# configure franciscolourenco/done
set -U __done_allow_nongraphical 1
set -U __done_exclude 'nvim|vim'

if status --is-interactive
  fzf_configure_bindings --directory=\cf

  /usr/local/bin/direnv hook fish | source

  /usr/local/bin/starship init fish | source

  /usr/local/bin/zoxide init fish --cmd cd | source

  # upgrade open-file limit for vim & docs.rs
  ulimit -n 10000

  # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
  complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
end

# vim: et ts=2 sts=2 sw=2
