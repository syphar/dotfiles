#!/bin/bash
set -euo pipefail

src_dir="$HOME/src"

echo "$HOME/.config/nvim/"

(
    # all Cargo projects including sub-crates
    $HOME/bin/runcached --ignore-env --ttl 86400 \
        fd Cargo.toml "$src_dir" --exec-batch printf "%s\n" \{//\}/

    # all git repos, a little slow
    $HOME/bin/runcached --ignore-env --ttl 86400 \
        $HOME/src/dotfiles/find_repos.sh "$src_dir"
) | sort | uniq
