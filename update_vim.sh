#!/bin/bash
set -euxo pipefail

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# nvim "+call dein#update()" +qa
# nvim --headless "+TSUpdate" +qa
