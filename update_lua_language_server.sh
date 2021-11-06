#!/bin/bash
set -euxo pipefail

cd ~/src/lua-language-server/

git submodule update --init --recursive
cd 3rd/luamake
compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
