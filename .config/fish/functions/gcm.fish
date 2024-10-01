# checkout default branch
function gcm
    if git show-ref --verify --quiet refs/heads/master
        git checkout master
    else if git show-ref --verify --quiet refs/heads/main
        git checkout main
    else
        echo "Neither master nor main branch exists."
    end
end
