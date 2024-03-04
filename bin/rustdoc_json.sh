#!/bin/bash
set -euo pipefail

cargo +nightly rustdoc -- -Zunstable-options --output-format json
