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

## cleanup
brew cleanup -s

## install/update pipx packages
xargs -n 1 pipx install --include-deps < pipx_list.txt 1>/dev/null || echo "fail but OK"
pipx reinstall-all
pipx inject python-lsp-server pylsp-mypy
pipx inject httpie httpie-ntlm

## rust environment
rustup update
cargo install-update -a

## global NPM packages
./npm-upgrade.sh

## binaries from github releases
./update_rust_analyzer.sh
./update_zeta_note.sh

## cleanup dmypy processes
./kill_mypyd.sh

## tldr update
tldr --update || echo "failed, but ignore for now"

## bat cache
bat cache --build

## mackup
mackup restore --force
mackup backup

# update certain virtualenv
# ./update_virtualenv.sh "$SRC_DIR/pyls/venv" "python-language-server"
./update_virtualenv.sh "$SRC_DIR/neovim_env/venv"

# copy mackup files to dotfiles
./mackup_dotfiles.py

# update fisher
fish -c "fisher update"
./clean_fish.sh 

./update_lua_language_server.sh
./update_vim.sh

# update tmux plugins
./find_repos.sh "$HOME/.tmux/plugins" | xargs -n 1 sh -c './update_git_repo.sh $0 || exit 255'

# update all source repos
./find_repos.sh "$SRC_DIR" | xargs -n 1 sh -c './update_git_repo.sh $0 || exit 255'
