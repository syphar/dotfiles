#!/bin/bash
set -euo pipefail

echo "rebuilding $1 $2"

http \
    --verify=no \
    -A bearer \
    -a "${DOCSRS_CRATESIO_TOKEN}" \
    --print=hb \
    POST https://docs.rs/crate/"$1"/"$2"/rebuild
