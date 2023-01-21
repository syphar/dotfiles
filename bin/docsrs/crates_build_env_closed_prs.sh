#!/bin/bash
set -euo pipefail

gh pr list \
    --repo rust-lang/crates-build-env \
    --state closed \
    --limit 100 \
    --json number,url,title \
    | jq -r '.[] | "* [#\(.number) - \(.title)](\(.url))"'
