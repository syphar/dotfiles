#!/bin/bash
set -euo pipefail

echo "rebuilding $1 $2"

http \
    --verify=no \
    -A bearer \
    -a "${DOCS_RS_CRATES_IO_TOKEN}" \
    --print=hb \
    POST https://docs.rs/crate/"$1"/"$2"/rebuild
