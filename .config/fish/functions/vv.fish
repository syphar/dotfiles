# open a file from this projects with vim
function vv
  set fn (
    fd --type f --type l --hidden --follow --exclude .git 2>/dev/null \
    | fzf
  )
  if test $status -eq 0
      eval $EDITOR $fn
  end

  commandline -f repaint
end
