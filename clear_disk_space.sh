#!/bin/bash
set -euo pipefail

SRC_DIR="$HOME/src"

echo "delete all .direnv directories"
(cd "$SRC_DIR" && fd --type d --no-ignore --hidden "^\.direnv$" --exec rm -rf {})

echo "delete caches"
rm -rf "$HOME/Library/Caches/*"

echo "clear cargo cache"
cargo cache --autoclean-expensive

echo "wipe docker data"
docker container prune -f
docker image prune -a -f
docker builder prune -a -f
docker volume prune -f
docker volume prune -f
