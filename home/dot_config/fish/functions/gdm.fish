# diff to main branch
function gdm
    set -l b (_git_default_branch); or return 1
    git-forgit diff $b...
end
