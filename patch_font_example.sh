#!/bin/bash

docker run \
    -v ~/src/dotfiles/IBMPlexMono2:/in \
    -v ~/src/dotfiles/IBMPlexMono2/out:/out \
    nerdfonts/patcher \
    --fontawesome \
    --fontawesomeextension \
    --fontlinux \
    --fontlogos \
    --octicons \
    --powersymbols \
    --pomicons \
    --powerline \
    --powerlineextra \
    --material \
    --weather

