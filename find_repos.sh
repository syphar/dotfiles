#!/bin/bash
set -euo pipefail

(cd "$1" && fd --type d --no-ignore --hidden "^\.git$" --exec echo $1/\{//\})
