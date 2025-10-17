#!/usr/bin/env bash
set -euo pipefail

MANDATORY_COMPONENTS=(clippy rust-analyzer)

for toolchain in $(rustup toolchain list | awk '{print $1}'); do
  echo "==> Installing mandatory components for $toolchain"
  for component in "${MANDATORY_COMPONENTS[@]}"; do
    rustup component add "$component" --toolchain "$toolchain" || echo "  [!] $component not available for $toolchain"
  done
done
