#!/bin/bash
set -euo pipefail

dest="$HOME/.local/bin/$1"
url="https://github.com/$2/releases/latest/download/$3"
rm -rf "$dest"
curl --compressed -L "$url" > "$dest"
chmod +x "$dest"
