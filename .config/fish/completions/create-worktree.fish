function __fish_create_worktree_branches
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return

    set -l main_repo (_git_main_repo 2>/dev/null); or return

    command git -C "$main_repo" for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin \
        | string replace -r '^origin/' '' \
        | string match -v HEAD \
        | sort -u
end

complete -c create-worktree -f \
    -n 'test (count (commandline -opc)) -eq 1' \
    -a '(__fish_create_worktree_branches)' \
    -d 'Git branch'
