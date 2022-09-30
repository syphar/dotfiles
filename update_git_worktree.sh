#!/bin/bash
set -euo pipefail

echo "#################################"
echo "updating git worktree: $1"

cd "$1"

~/bin/rebuild_tags.sh

if [ -n "$(git remote)" ];
then
    git merge --ff-only || echo "merge failed, but ok"
fi
