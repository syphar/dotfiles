function create-worktree --argument-names branch_name
    if test (count $argv) -ne 1
        echo "create-worktree: usage: create-worktree <name>" >&2
        return 1
    end

    set -l main_repo (_git_main_repo); or return 1

    set -l main_name (path basename "$main_repo")
    set -l repo_parent (path dirname "$main_repo")
    set -l worktree_suffix (string replace -a / - -- "$branch_name")
    set -l worktree_name "$main_name-$worktree_suffix"
    set -l worktree_path "$repo_parent/$worktree_name"
    set -l branch_source local

    if not command git -C "$main_repo" show-ref --verify --quiet "refs/heads/$branch_name"
        if command git -C "$main_repo" show-ref --verify --quiet "refs/remotes/origin/$branch_name"
            command git -C "$main_repo" branch --track "$branch_name" "origin/$branch_name"; or begin
                echo "create-worktree: failed to create local tracking branch '$branch_name'" >&2
                return 1
            end
            set branch_source "origin/$branch_name"
        else
            echo "create-worktree: branch '$branch_name' does not exist locally or on origin" >&2
            return 1
        end
    end

    if test -e "$worktree_path"
        echo "create-worktree: worktree path '$worktree_path' already exists" >&2
        return 1
    end

    command git -C "$main_repo" worktree add "$worktree_path" "$branch_name"; or begin
        echo "create-worktree: failed to create worktree" >&2
        return 1
    end

    set -l env_files (command find "$main_repo" -maxdepth 1 -type f -name '.env*' -print)
    if test (count $env_files) -gt 0
        command cp $env_files "$worktree_path/"; or begin
            echo "create-worktree: failed to copy .env files" >&2
            return 1
        end
    end

    echo "create-worktree: created worktree for '$branch_name' at '$worktree_path' from '$branch_source'"

    command sesh connect "$worktree_path"
end
