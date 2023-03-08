#!/bin/bash
set -exuo pipefail

cd ~/src/just
cargo build --release

target="$HOME/bin/just"

rm -f $target 
mv "$HOME/.cargo/cache/release/just" $target
