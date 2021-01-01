#!/bin/bash
set -euo pipefail

df -h . | tail -1 | tr -s ' ' | cut -d' ' -f4
