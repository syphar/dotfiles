# open a file from this projects with vim
function vv
  set file (
    eval "$FZF_DEFAULT_COMMAND" |
    fzf
  ); \
  and $EDITOR $file

  commandline -f repaint
end
