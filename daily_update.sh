#!/bin/bash
set -euxo pipefail

SRC_DIR="$HOME/src"

## update self
git pull

## update homebrew
brew update && brew upgrade && brew upgrade --cask

## install missing packages
brew bundle --no-upgrade --no-lock --quiet 1>/dev/null

## dump new brew packages
brew bundle dump -f

## cleanup
brew cleanup -s

## update zsh
(cd ~/.zprezto && git pull && git submodule update --init --recursive)

## install/update pipx packages
xargs -n 1 pipx install < pipx_list.txt 1>/dev/null
pipx reinstall-all

## rust environment
rustup update
cargo install-update -a

## rust-analyzer
rust_analyzer_bin="$HOME/.local/bin/rust-analyzer"
ra_source="https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-mac"
rm -rf "$rust_analyzer_bin"
curl --compressed -L -o "$rust_analyzer_bin" "$ra_source"
chmod +x "$rust_analyzer_bin"

## tldr update
tldr --update

## bat cache
bat cache --build

## mackup
mackup restore --force
mackup backup

# update certain virtualenv
./update_virtualenv.sh "$SRC_DIR/pyls/venv" "python-language-server"
./update_virtualenv.sh "$SRC_DIR/neovim_env/venv"

# copy mackup files to dotfiles
./mackup_dotfiles.py

# update zsh plugins
./find_repos.sh "$HOME/.zprezto-contrib" | xargs -n 1 ./update_git_repo.sh

# update tmux plugins
./find_repos.sh "$HOME/.tmux/plugins" | xargs -n 1 ./update_git_repo.sh

# update all source repos
./find_repos.sh "$SRC_DIR" | xargs -n 1 ./update_git_repo.sh

# update vim
./update_vim.sh
