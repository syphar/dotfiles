#!/bin/bash
set -exuo pipefail

SRC_DIR="$HOME/src"

echo "delete all .direnv directories"
fd --type d --no-ignore --hidden "^\.direnv$" "$SRC_DIR" --exec rm -rf {}

echo "delete caches"
rm -rf "$HOME/Library/Caches/*"

echo "clear cargo cache"
cargo cache --autoclean

echo "wipe docker data"
docker container prune -f
docker image prune -a -f
docker builder prune -a -f
docker volume prune -f
docker volume prune -f

echo "clear rust target directories"
fd Cargo.toml "$SRC_DIR" --exec rm -rf \{//\}/target

# clear thermondo backups
rm -rf "$SRC_DIR/thermondo/backend/sql/backups"
