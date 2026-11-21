#!/bin/bash 

for dep in $(cargo metadata --no-deps --format-version 1 \
  | jq -r '.packages[] | select(.source == null) | .dependencies[].name' | sort -u); do
  echo -n "$dep: "
  cargo tree -i $dep -e=no-dev | wc -l
done | sort -k2 -n
