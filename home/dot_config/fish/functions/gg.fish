function gg
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or begin
        echo "gg: not inside a git repository" >&2
        return 1
    end

    # # Refresh remote tracking refs so [gone] status is current.
    # command git fetch --all --prune --quiet; or begin
    #     echo "gg: fetch --prune failed" >&2
    #     return 1
    # end

    set -l gone_branches (
        command git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads \
        | string match -r '.+ \[gone\]$' \
        | string replace -r ' \[gone\]$' ''
    )

    if test (count $gone_branches) -eq 0
        echo "gg: no branches with gone upstream"
        return 0
    end

    # Protect common long-lived branches from accidental deletion.
    set -l protected main master develop dev
    for b in $protected
        set gone_branches (string match -v $b $gone_branches)
    end

    if test (count $gone_branches) -eq 0
        echo "gg: only protected branches were found"
        return 0
    end

    printf "gg: deleting branches:\n%s\n" (string join \n $gone_branches)
    command git branch -D $gone_branches
end


