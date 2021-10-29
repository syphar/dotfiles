# cd in one of my projects
function cdp
    set dir (
    ~/src/dotfiles/find_projects.sh | fzf --tiebreak=end,index
  )
        and cd $dir
        and clear

    commandline -f repaint
end
