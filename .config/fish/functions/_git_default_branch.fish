function _git_default_branch -d "Echo the repo default branch name"
    set -l remote_default (command git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
    if test -n "$remote_default"
        echo (string replace 'origin/' '' -- "$remote_default")
        return 0
    end

    if git show-ref --verify --quiet refs/heads/main
        echo main
    else if git show-ref --verify --quiet refs/heads/master
        echo master
    else
        echo "_git_default_branch: could not determine default branch" >&2
        return 1
    end
end
