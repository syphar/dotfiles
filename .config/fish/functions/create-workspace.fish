function create-workspace --argument-names branch_name
    if test (count $argv) -ne 1
        echo "create-workspace: usage: create-workspace <name>" >&2
        return 1
    end

    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or begin
        echo "create-workspace: not inside a git repository" >&2
        return 1
    end

    set -l git_common_dir (command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    test -n "$git_common_dir"; or begin
        echo "create-workspace: failed to resolve git common dir" >&2
        return 1
    end

    set -l main_repo (path dirname "$git_common_dir")
    set -l base_branch
    if command git -C "$main_repo" show-ref --verify --quiet refs/heads/main
        set base_branch main
    else if command git -C "$main_repo" show-ref --verify --quiet refs/heads/master
        set base_branch master
    else
        echo "create-workspace: could not find local main or master branch" >&2
        return 1
    end

    if command git -C "$main_repo" show-ref --verify --quiet "refs/heads/$branch_name"
        echo "create-workspace: local branch '$branch_name' already exists" >&2
        return 1
    end

    if command git -C "$main_repo" show-ref --verify --quiet "refs/remotes/origin/$branch_name"
        echo "create-workspace: origin branch '$branch_name' already exists" >&2
        return 1
    end

    command git -C "$main_repo" branch "$branch_name" "$base_branch"; or begin
        echo "create-workspace: failed to create branch '$branch_name' from '$base_branch'" >&2
        return 1
    end

    create-worktree "$branch_name"; or begin
        echo "create-workspace: failed to create worktree for '$branch_name'" >&2
        return 1
    end
end
