# open a file from this projects with vim
function vv
  set filename (
    fd --color=always --type f --type l --hidden --follow --exclude .git 2>/dev/null \
    | fzf
  )
  if test $status -eq 0
      eval $EDITOR $filename
  end

  commandline -f repaint
end


# old zsh command
# local file
# file=$(
#   eval "$FZF_DEFAULT_COMMAND" |
#   fzf
# ) && $EDITOR $file
