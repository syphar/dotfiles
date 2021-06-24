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
# brew bundle dump -f

## delete packages not in dump
brew bundle cleanup -f

# reinstall ctags because it sucks
brew uninstall universal-ctags
brew install --HEAD universal-ctags

## cleanup
brew cleanup -s

## install/update pipx packages
xargs -n 1 pipx install < pipx_list.txt 1>/dev/null || echo "fail but OK"
pipx reinstall-all

## rust environment
rustup update
cargo install-update -a

## global NPM packages
./npm-upgrade.sh

## rust-analyzer
./update_rust_analyzer.sh

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

# update fisher
fish -c "fisher update"

# update tmux plugins
./find_repos.sh "$HOME/.tmux/plugins" | xargs -n 1 sh -c './update_git_repo.sh $0 || exit 255'

# update all source repos
./find_repos.sh "$SRC_DIR" | xargs -n 1 sh -c './update_git_repo.sh $0 || exit 255'

# update vim
./update_vim.sh
