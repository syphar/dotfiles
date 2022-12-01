#!/bin/bash
set -euo pipefail

gh pr list \
    --repo rust-lang/docs.rs \
    --state closed \
    --label "S-waiting-on-deploy" \
    --json number,url,title \
    | jq -r '.[] | "* [\(.number) - \(.title)](\(.url))"'
