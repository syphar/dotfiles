#!/bin/sh

set -e
set -x

for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
do
    npm -g install "$package"
done

xargs -n 1 npm install -g < global_npm_packages.txt 
