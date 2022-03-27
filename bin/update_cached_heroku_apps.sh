#!/bin/bash

fn="$HOME/.cache/heroku_apps"
touch "$fn"

heroku apps --all --json | jq -r '. | map("\(.name)") | .[]' >> "$fn"

# sort & get rid of duplicates 
sort -u -o "$fn" "$fn"

# print final count
wc -l "$fn" 
