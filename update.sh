#!/bin/bash

echo HOMEBREW
brew update
brew upgrade

echo ZSH
cd ~/.oh-my-zsh/
git checkout master
git pull

echo SPF13-VIM
cd ~/.spf13-vim-3/
git checkout 3.0
git pull
vim +BundleInstall! +BundleClean +qa


echo PIP global
cd /tmp
pip freeze --local | cut -d = -f 1  | xargs pip install -U

