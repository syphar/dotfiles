#!/bin/bash
set -euxo pipefail

SRC_DIR="$HOME/src"

## update self
git pull

## heroku login, so we can fetch from heroku remotes later 
heroku whoami || heroku login

## update cached heroku apps list
update_cached_heroku_apps

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

## luarocks packages
xargs -n 1 luarocks install < luarocks_list.txt || echo "fail but OK"

## luarocks packages for lua 5.1, for neovim
xargs -n 1 luarocks install --lua-version 5.1 < luarocks_list.txt || echo "fail but OK"

## install/update pipx packages
xargs -n 1 pipx install --include-deps < pipx_list.txt 1>/dev/null || echo "fail but OK"
pipx reinstall-all
pipx inject python-lsp-server pylsp-mypy
pipx inject httpie httpie-ntlm
pipx inject poetry poetry-dynamic-versioning
pipx inject ipython rich requests

./update_generated_autocompletes.sh

## update cached pypi package list
# regex /ggrep via https://unix.stackexchange.com/a/13472/388999
curl -s "https://pypi.org/simple/" | ggrep -oP '(?<=/simple/)[^/]+(?=/)' > ~/.cache/pypi_packages.txt

## rust environment
rustup update
cargo install-update -a

## global NPM packages
./npm-upgrade.sh

## global Yarn packages
./yarn-upgrade.sh

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

./update_vim.sh

# update tmux plugins
./find_repos.sh "$HOME/.tmux/plugins" | xargs -n 1 sh -c './update_git_repo.sh $0 || exit 255'

# update all source repos
./find_repos.sh "$SRC_DIR" | xargs -n 1 sh -c './update_git_repo.sh $0 || exit 255'
