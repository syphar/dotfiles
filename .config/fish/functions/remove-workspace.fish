function remove-workspace
    set -l force_worktree_flag

    if test (count $argv) -gt 1
        echo "remove-workspace: usage: remove-workspace [--force]" >&2
        return 1
    end

    if test (count $argv) -eq 1
        switch $argv[1]
            case --force -f
                set force_worktree_flag --force
            case '*'
                echo "remove-workspace: usage: remove-workspace [--force]" >&2
                return 1
        end
    end

    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or begin
        echo "remove-workspace: not inside a git repository" >&2
        return 1
    end

    set -l git_common_dir (command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    test -n "$git_common_dir"; or begin
        echo "remove-workspace: failed to resolve git common dir" >&2
        return 1
    end

    set -l main_repo (path dirname "$git_common_dir")
    set -l current_worktree (command git rev-parse --show-toplevel 2>/dev/null)
    test -n "$current_worktree"; or begin
        echo "remove-workspace: failed to resolve current worktree" >&2
        return 1
    end

    if test "$current_worktree" = "$main_repo"
        echo "remove-workspace: must be run from a linked worktree" >&2
        return 1
    end

    set -l branch_name (command git branch --show-current 2>/dev/null)
    test -n "$branch_name"; or begin
        echo "remove-workspace: detached HEAD is not supported" >&2
        return 1
    end

    if contains -- "$branch_name" main master
        echo "remove-workspace: refusing to delete protected branch '$branch_name'" >&2
        return 1
    end

    set -l worktree_status (command git status --porcelain)
    if test -n "$worktree_status"; and test -z "$force_worktree_flag"
        echo "remove-workspace: worktree has uncommitted changes; rerun with --force" >&2
        return 1
    end

    cd "$main_repo"; or begin
        echo "remove-workspace: failed to cd into '$main_repo'" >&2
        return 1
    end

    command git -C "$main_repo" worktree remove $force_worktree_flag "$current_worktree"; or begin
        echo "remove-workspace: failed to remove worktree '$current_worktree'" >&2
        return 1
    end

    echo "remove-workspace: removed '$current_worktree' for branch '$branch_name'"
end
