#!/bin/bash
set -euo pipefail

dest="$HOME/.local/bin/$1"
url="https://github.com/$2/releases/latest/download/$3"
rm -rf "$dest"

if [[ "$3" =~ ".gz" ]]; then
    curl --compressed -L "$url" | gunzip -c - > "$dest"
else
    curl --compressed -L "$url" > "$dest"
fi


chmod +x "$dest"
