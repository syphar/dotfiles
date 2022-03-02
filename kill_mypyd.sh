#!/bin/bash
set -exuo pipefail

pkill -f dmypy || echo "nothing to kill"
