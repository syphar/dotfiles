#!/bin/bash
set -euxo pipefail

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c "TSInstallSync maintained" -c "TSUpdateSync" -c "quitall"
