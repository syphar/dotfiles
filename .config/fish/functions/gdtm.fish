# difftool to main branch
function gdtm
    if git show-ref --verify --quiet refs/heads/master
        git difftool master...
    else if git show-ref --verify --quiet refs/heads/main
        git difftool main...
    else
        echo "Neither master nor main branch exists."
    end
end

