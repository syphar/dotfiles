function gpc
    set branch (
      git branch --show-current
    ); \
    and git push --set-upstream origin $branch $argv
end
