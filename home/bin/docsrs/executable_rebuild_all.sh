#!/bin/bash
set -euo pipefail

while read -r name version; do
    version=${version%$'\r'}
    [[ -z $name ]] && continue
    echo "crate=$name version=$version"
    ./rebuild.sh "$name" "$version"
done < $1 
