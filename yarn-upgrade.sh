#!/bin/sh

set -e
set -x

yarn global upgrade

xargs -n 1 yarn global add < global_yarn_packages.txt 
