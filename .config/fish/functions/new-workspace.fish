function new-workspace --argument-names branch_name
    if test (count $argv) -ne 1
        echo "new-workspace: usage: new-workspace <name>" >&2
        return 1
    end

    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or begin
        echo "new-workspace: not inside a git repository" >&2
        return 1
    end

    set -l git_common_dir (command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    test -n "$git_common_dir"; or begin
        echo "new-workspace: failed to resolve git common dir" >&2
        return 1
    end

    set -l main_repo (path dirname "$git_common_dir")
    set -l main_name (path basename "$main_repo")
    set -l repo_parent (path dirname "$main_repo")
    set -l worktree_suffix (string replace -a / - -- "$branch_name")
    set -l worktree_name "$main_name-$worktree_suffix"
    set -l worktree_path "$repo_parent/$worktree_name"

    set -l base_branch
    if command git -C "$main_repo" show-ref --verify --quiet refs/heads/main
        set base_branch main
    else if command git -C "$main_repo" show-ref --verify --quiet refs/heads/master
        set base_branch master
    else
        echo "new-workspace: could not find local main or master branch" >&2
        return 1
    end

    if command git -C "$main_repo" show-ref --verify --quiet "refs/heads/$branch_name"
        echo "new-workspace: local branch '$branch_name' already exists" >&2
        return 1
    end

    if command git -C "$main_repo" for-each-ref --format='%(refname:strip=3)' refs/remotes | string match -q -- "$branch_name"
        echo "new-workspace: remote branch '$branch_name' already exists" >&2
        return 1
    end

    if test -e "$worktree_path"
        echo "new-workspace: worktree path '$worktree_path' already exists" >&2
        return 1
    end

    command git -C "$main_repo" worktree add -b "$branch_name" "$worktree_path" "$base_branch"; or begin
        echo "new-workspace: failed to create worktree" >&2
        return 1
    end

    set -l env_files (command find "$main_repo" -maxdepth 1 -type f -name '.env*' -print)
    if test (count $env_files) -gt 0
        command cp $env_files "$worktree_path/"; or begin
            echo "new-workspace: failed to copy .env files" >&2
            return 1
        end
    end

    cd "$worktree_path"; or begin
        echo "new-workspace: failed to cd into '$worktree_path'" >&2
        return 1
    end

    echo "new-workspace: created '$branch_name' from '$base_branch' at '$worktree_path'"
end
