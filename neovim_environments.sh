#!/bin/bash
set -exuo pipefail

SRC_DIR="$HOME/src"

# https://github.com/pyenv/pyenv/issues/1643#issuecomment-755067511
LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" pyenv install 3.8.6 || echo " already there"

py=~/.pyenv/versions/3.8.6/bin/python

neovim_dir=$SRC_DIR/neovim_env
rm -rf $neovim_dir

(
    mkdir -p $neovim_dir &&
    cd $neovim_dir &&
    $py -m venv venv &&
    $neovim_dir/venv/bin/pip install neovim pynvim
)

pyls_dir=$SRC_DIR/pyls
rm -rf $pyls_dir

(
    mkdir -p $pyls_dir &&
    cd $pyls_dir &&
    $py -m venv venv &&
    $pyls_dir/venv/bin/pip install python-language-server
)
