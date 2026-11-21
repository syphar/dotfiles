#!/usr/bin/env bash 

# coming from github: Updating a local clone after a branch name changes
# https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/renaming-a-branch#updating-a-local-clone-after-a-branch-name-changes
git branch -m master main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a
