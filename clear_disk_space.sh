#!/bin/bash
set -exuo pipefail

SRC_DIR="$HOME/src"

echo "remove all pyenv versions"
rm -rf ~/.pyenv/versions/*

echo "delete all .direnv, .tox or node_modules directories"
fd --type d --no-ignore --hidden "^\.direnv$" "$SRC_DIR" --exec rm -rf {}
fd --type d --no-ignore --hidden "^\.tox$" "$SRC_DIR" --exec rm -rf {}
fd --type d --no-ignore --prune node_modules "$SRC_DIR" --exec rm -rf {}

echo "delete caches"
rm -rf ~/Library/Caches/*
rm -rf ~/Library/Developer/CoreSimulator/Caches/*

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
rm -rf ~/src/rust-lang/docs.rs/.rustwide-docker

# clear thermondo backups
rm -rf "$SRC_DIR/thermondo/backend/sql/backups"

# delete some logs
rm -rf /usr/local/var/log/*
