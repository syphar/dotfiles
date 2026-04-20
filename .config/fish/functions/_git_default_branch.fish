function _git_default_branch -d "Echo the repo default branch name"
    if git show-ref --verify --quiet refs/heads/main
        echo main
    else if git show-ref --verify --quiet refs/heads/master
        echo master
    else
        echo "_git_default_branch: could not determine default branch" >&2
        return 1
    end
end
