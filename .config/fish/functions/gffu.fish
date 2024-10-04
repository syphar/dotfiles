# fetch from upstream/main&master
function gffu
    if git show-ref --verify --quiet refs/remotes/upstream/master
        git ff upstream/master
    else if git show-ref --verify --quiet refs/remotes/upstream/main
        git ff upstream/main
    else
        echo "Neither master nor main branch exists."
    end
end

