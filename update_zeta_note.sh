#!/bin/bash
set -euo pipefail

zeta_note_bin="$HOME/.local/bin/zeta-note"
zn_source="https://github.com/artempyanykh/zeta-note/releases/latest/download/zeta-note-macos"

rm -rf "$zeta_note_bin"
curl --compressed -L "$zn_source" > "$zeta_note_bin"
chmod +x "$zeta_note_bin"
