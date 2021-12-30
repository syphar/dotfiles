#!/bin/bash
set -euxo pipefail

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c "TSUpdateSync" -c "quitall"
