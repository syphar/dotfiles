# checkout default branch
function gcm
    set -l b (_git_default_branch); or return 1
    git checkout $b
end
