# difftool to main branch
function gdtm
    set -l b (_git_default_branch); or return 1
    git difftool $b...
end
