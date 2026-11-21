function _git_main_repo -d "Resolve and echo the absolute path of the main (non-worktree) repo"
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or begin
        echo "_git_main_repo: not inside a git repository" >&2
        return 1
    end

    set -l git_common_dir (command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    test -n "$git_common_dir"; or begin
        echo "_git_main_repo: failed to resolve git common dir" >&2
        return 1
    end

    path dirname "$git_common_dir"
end
