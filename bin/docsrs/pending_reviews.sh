#!/bin/bash
set -euo pipefail

gh pr list \
    --repo rust-lang/docs.rs \
    --state open \
    --label "S-waiting-on-review" \
    --json number,url,title \
    | jq -r '.[] | "* [#\(.number) - \(.title)](\(.url))"'
