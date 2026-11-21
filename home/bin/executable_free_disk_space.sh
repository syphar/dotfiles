#!/bin/bash
set -euo pipefail

df -h | grep "$1" | tr -s ' ' | cut -d' ' -f4
