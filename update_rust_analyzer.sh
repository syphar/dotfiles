#!/bin/bash
set -euo pipefail

rust_analyzer_bin="$HOME/.local/bin/rust-analyzer"
ra_source="https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-apple-darwin.gz"
rm -rf "$rust_analyzer_bin"
curl -L "$ra_source" | gunzip -c > "$rust_analyzer_bin"
chmod +x "$rust_analyzer_bin"
