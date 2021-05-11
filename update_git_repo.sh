#!/bin/bash
set -euo pipefail

echo "#################################"
echo "updating git repo: $1"

cd "$1"

ln -s $HOME/src/dotfiles/git-hooks/* "$1/.git/hooks" || echo "already exists"

git gc

if [ -n "$(git remote)" ];
then
    git fetch --all --recurse-submodules=yes --prune
    git fetch --all --prune --tags --force
    git merge --ff-only || echo "merge failed, but ok"
fi
