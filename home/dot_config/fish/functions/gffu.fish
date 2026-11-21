# fetch from upstream/main or upstream/master
function gffu
    set -l b (_git_default_branch); or return 1
    git ff upstream/$b
end
