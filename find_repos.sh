#!/bin/bash
set -euo pipefail

fd \
    --type d \
    --exclude "target" \
    --exclude "node_modules" \
    --exclude ".direnv" \
    --exclude "venv" \
    --exclude "venv2" \
    --prune \
    --no-ignore \
    --hidden \
    "^\.git$" \
    "$1" \
    --exec-batch printf "%s\n" \{//\}/
