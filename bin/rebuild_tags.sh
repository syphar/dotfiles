#!/bin/bash
set -euo pipefail

rm -f tags && git ls-files . --cached --exclude-standard --others | ctags -L -
