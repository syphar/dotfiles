#!/bin/bash
set -euxo pipefail

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c "TSInstallSync all" -c "TSUpdateSync" -c "quitall"
