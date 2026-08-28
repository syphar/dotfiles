#!/bin/bash
set -euo pipefail

fd \
    --type f \
    --no-ignore \
    --hidden \
    --exclude target \
    "^\.git\$" \
    "$1" \
    --exec-batch printf "%s\n" \{//\}/
