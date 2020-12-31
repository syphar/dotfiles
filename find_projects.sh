#!/bin/bash
set -euo pipefail

src_dir="$HOME/src"

echo "$HOME/.config/nvim/"

(
    # starting in src_dir
    cd "$src_dir"

    # all Cargo projects including sub-crates
    fd Cargo.toml --exec echo $src_dir/\{//\}/ &

    # all git repos, a little slow
    $HOME/src/dotfiles/find_repos.sh "$src_dir" &
)
