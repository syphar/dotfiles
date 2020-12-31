#!/bin/bash
set -euo pipefail

src_dir="$HOME/src/"

echo "$HOME/.config/nvim/"

(
    cd "$src_dir" &&
    fd Cargo.toml --exec echo $src_dir\{//\}/ &&
    fd --type d --exclude "target" --exclude "node_modules" --exclude ".direnv" --prune --no-ignore --hidden "^\.git$" --exec echo $src_dir\{//\}/
)
