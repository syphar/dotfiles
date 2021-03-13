#!/bin/bash
set -euo pipefail

src_dir="$HOME/src"

echo "$HOME/.config/nvim/"

(
    # all Cargo projects including sub-crates
    $HOME/bin/runcached \
        fd Cargo.toml "$src_dir" --exec-batch printf "%s\n" \{//\}/

    # all Go projects
    $HOME/bin/runcached \
        fd go.mod "$src_dir" --exec-batch printf "%s\n" \{//\}/

    # all git repos, a little slow
    $HOME/bin/runcached \
        $HOME/src/dotfiles/find_repos.sh "$src_dir"
) | sort | uniq
