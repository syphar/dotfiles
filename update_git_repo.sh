#!/bin/bash
set -euo pipefail

echo "#################################"
echo "updating git repo: $1"

cd "$1"

~/bin/rebuild_tags.sh

if [ -f "$1/.pre-commit-config.yaml" ]; then 
    if [ ! -f "$1/.git/hooks/pre-commit" ]; then
        echo "pre-commit not found, installing..."
        pre-commit install
    else 
        echo "pre-commit found"
    fi
fi

if [ -f "$1/.git-blame-ignore-revs" ]; then 
    git config blame.ignoreRevsFile .git-blame-ignore-revs
fi

ln -s $HOME/src/dotfiles/git-hooks/* "$1/.git/hooks" || echo "already exists"

git gc

if [ -n "$(git remote)" ];
then
    git fetch --all --recurse-submodules=yes --prune
    git fetch --all --prune --tags --force
    git merge --ff-only || echo "merge failed, but ok"
    git branch -v | grep "\[gone\]" | awk '{print $1}' | xargs git branch -D || echo "failed, but ok"
fi
