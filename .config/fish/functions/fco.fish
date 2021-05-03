# fco - checkout git branch (including remote branches), sorted by most recent commit
# remote branches are checked out as a new local branch if they don't exist
function fco
  set -l branch (
    git for-each-ref --sort=-committerdate refs/ --format="%(refname:short)" |
    fzf \
      --no-sort \
      --preview="git --no-pager branchdiff -150 '..{}'"
  ); \
  and git checkout (echo "$branch" | sed "s/origin\///");

  commandline -f repaint
end
