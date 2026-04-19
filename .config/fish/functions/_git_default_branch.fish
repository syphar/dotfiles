function _git_default_branch -d "Echo the default branch name (main or master)"
    if git show-ref --verify --quiet refs/heads/main
        echo main
    else if git show-ref --verify --quiet refs/heads/master
        echo master
    else
        echo "_git_default_branch: neither main nor master branch exists" >&2
        return 1
    end
end
