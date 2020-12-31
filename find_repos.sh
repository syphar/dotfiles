#!/bin/bash
set -euo pipefail

(
    cd $1 &&
    fd \
        --type d \
        --exclude "target" \
        --exclude "node_modules" \
        --exclude ".direnv" \
        --exclude "venv" \
        --exclude "venv2" \
        --prune \
        --no-ignore \
        --hidden "^\.git$" \
        --exec echo $1/\{//\}/
)
