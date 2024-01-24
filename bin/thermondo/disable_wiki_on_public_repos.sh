#!/usr/bin/env bash

for repo in $(gh repo list thermondo --limit 9999 --no-archived --visibility public --json name --jq .[].name); do
    echo "$repo"
    gh repo edit "thermondo/$repo" --enable-wiki=false --enable-projects=false
done

