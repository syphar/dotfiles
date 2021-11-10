function crate
    fd --type f --exclude ".last_updated" --exclude "config.json" . ~/.cargo/registry/index/github.com-1ecc6299db9ec823/ | 
        sed 's|^.*/||' | 
        fzf
end
