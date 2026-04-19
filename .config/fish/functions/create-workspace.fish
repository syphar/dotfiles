function create-workspace --argument-names branch_name
    if test (count $argv) -ne 1
        echo "create-workspace: usage: create-workspace <name>" >&2
        return 1
    end

    set -l main_repo (_git_main_repo); or return 1

    set -l base_branch (_git_default_branch); or begin
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
