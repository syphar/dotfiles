# diff to main branch
function gdm
    if git show-ref --verify --quiet refs/heads/master
        git-forgit diff master...
    else if git show-ref --verify --quiet refs/heads/main
        git-forgit diff main...
    else
        echo "Neither master nor main branch exists."
    end
end

