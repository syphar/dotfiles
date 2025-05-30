#!/usr/bin/env just --justfile

export SRC_DIR := "/Users/syphar/src"

default:
    just --list

daily-update:
    git pull # to allow SSH key access in 1p, once, so later steps can use it
    just heroku-cli
    just gcloud-cli
    update_cached_heroku_apps
    just update-homebrew
    just update-luarocks
    just update-pipx
    just update-generated-autocompletes
    just update-cached-pypi-package-list
    just update-rust
    just npm-upgrade
    just kill-leftover-background-processes
    just tldr-update

    gh extension upgrade --all

    bat cache --build

    just mackup
    just update-fish
    just update-vim

    # github packages downloads
    ./download_github_release.sh marksman artempyanykh/marksman marksman-macos
    ./download_github_release.sh tuc riquito/tuc tuc-macos-amd64 

    # update tmux plugins
    ./find_repos.sh "$HOME/.tmux/plugins" | xargs -n 1 sh -c 'just update-git-repo $0 || exit 255'

    just update-git-repos
    just update-git-worktrees

update-git-repos:
    ./find_repos.sh $SRC_DIR | xargs -n 1 sh -c 'just update-git-repo $0 || exit 255'

garbage-collect-git-repos:
    ./find_repos.sh $SRC_DIR | xargs -n 1 sh -c 'echo $0 && cd $0 && git gc --aggressive || exit 255'

update-git-worktrees:
    ./find_worktrees.sh $SRC_DIR | xargs -n 1 sh -c 'just update-git-worktree $0 || exit 255'

update-generated-autocompletes:
    poetry completions fish > ~/.config/fish/completions/poetry.fish
    poe _fish_completion > ~/.config/fish/completions/poe.fish
    _DSLR_COMPLETE=fish_source dslr > ~/.config/fish/completions/dslr.fish

mackup:
    uv pip install --upgrade -r requirements.txt
    ## mackup
    mackup restore --force
    mackup backup
    # copy mackup files to dotfiles
    ./mackup_dotfiles.py

kill-leftover-background-processes:
    ## cleanup dmypy processes
    pkill -f dmypy || echo "nothing to kill"
    ## cleanup pylsp processes
    pkill -f pylsp || echo "nothing to kill"

tldr-update:
    ## tldr update
    tldr --update || echo "failed, but ignore for now"

gcloud-cli:
    gcloud components update --quiet

heroku-cli:
    ## heroku login, so we can fetch from heroku remotes later 
    heroku whoami || heroku login
    ## update the Heroku CLI
    heroku update
    ## try to update the autocomplete cache
    heroku autocomplete zsh

update-homebrew:
    brew update && brew upgrade && brew upgrade --cask

    ## install missing packages
    brew bundle --no-upgrade --quiet 1>/dev/null

    ## delete packages not in dump
    brew bundle cleanup -f

    ## cleanup
    brew cleanup -s

update-luarocks:
    ## luarocks packages
    -xargs -n 1 luarocks install < luarocks_list.txt 

    ## luarocks packages for lua 5.1, for neovim
    -xargs -n 1 luarocks install --lua-version 5.1 < luarocks_list.txt 

update-pipx:
    ## install/update pipx packages
    -xargs -n 1 pipx install --include-deps < pipx_list.txt 1>/dev/null 
    pipx reinstall-all
    pipx inject python-lsp-server pylsp-mypy rope
    pipx inject httpie httpie-ntlm
    pipx inject httpie 'urllib3<2' # https://github.com/httpie/httpie/issues/1499
    pipx inject poetry poetry-dynamic-versioning poetry-plugin-export
    pipx inject ipython rich requests
    pipx inject dslr psycopg2-binary

update-vim:
    rm -f ~/.local/state/nvim/*.log

    nvim --headless '+Lazy! sync' +qa

npm-upgrade:
    #!/usr/bin/env bash
    set -euxo pipefail
    for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
    do
        npm -g install "$package"
    done

    xargs -n 1 npm install -g < global_npm_packages.txt 

cargo-sweep REPO:
    cd {{ REPO }} && \
        cargo sweep --time 30 && \
        cargo sweep --installed
     

update-cached-pypi-package-list:
    # regex /ggrep via https://unix.stackexchange.com/a/13472/388999
    curl --compressed -s "https://pypi.org/simple/" | ggrep -oP '(?<=/simple/)[^/]+(?=/)' > ~/.cache/pypi_packages.txt

update-rust:
    rustup update
    cargo install-update -a
    -/bin/cat cargo_install.txt | tr '\n' '\0' | xargs -0 -n1 cargo binstall

cargo-install:
    #!/usr/bin/env fish
    for line in (cat cargo_install.txt)
        eval (cargo binstall $line)
    end


update-fish: clean-fish
    # update fisher
    fish -c "fisher update"

clean-fish:
    rm -f ~/.config/fish/fishd.tmp.*
    rm -f ~/.config/fish/fish_variables*conflicted*

install-custom-rust-binary REPO BINARY_NAME:
    cd {{ REPO }} && cargo build --release

    rm -f $HOME/bin/{{ BINARY_NAME }}
    mv {{ REPO }}/target/release/{{ BINARY_NAME }} $HOME/bin/{{ BINARY_NAME }}

update-git-repo REPO:
    #!/bin/bash
    set -euo pipefail

    if [ -e "{{ REPO }}/Cargo.toml" ] && [ -d "{{ REPO }}/target" ]; then
        just cargo-sweep "{{ REPO }}"
    fi

    cd "{{ REPO }}"

    ~/bin/rebuild_tags.sh

    if [ -f "{{ REPO }}/.pre-commit-config.yaml" ]; then 
        if [ ! -f "{{ REPO }}/.git/hooks/pre-commit" ]; then
            echo "pre-commit not found, installing..."
            pre-commit install
        else 
            echo "pre-commit found"
        fi
    fi

    if [ -f "{{ REPO }}/.git-blame-ignore-revs" ]; then 
        git config blame.ignoreRevsFile .git-blame-ignore-revs
    fi

    ln -s $HOME/src/dotfiles/git-hooks/* "{{ REPO }}/.git/hooks" || echo "already exists"

    git gc

    if [ -n "$(git remote)" ];
    then
        git fetch --all --recurse-submodules=yes --prune --force
        git fetch --all --prune --tags --force
        git merge --ff-only || echo "merge failed, but ok"
        git branch -v | grep "\[gone\]" | awk '{print $1}' | xargs git branch -D || echo "failed, but ok"
    fi

update-git-worktree REPO:
    #!/bin/bash
    set -euo pipefail

    cd "{{ REPO }}"

    ~/bin/rebuild_tags.sh

    if [ -n "$(git remote)" ];
    then
        git merge --ff-only || echo "merge failed, but ok"
    fi

clear-disk-space:
    just clear-thermondo-backups
    just clear-logs
    just clear-docker
    just clear-cargo-cache
    just clear-dev-environments
    just clear-caches
    just clear-rust-target-directories
    just clear-docsrs-dev
    just garbage-collect-git-repos


clear-thermondo-backups:
    fd --type f --full-path --no-ignore ".*/sql/backup/.*\.sql" "$SRC_DIR/thermondo/" --exec rm -rf {}

clear-logs:
    rm -rf /usr/local/var/log/*

clear-docker:
    docker container prune -f
    docker image prune -a -f
    docker builder prune -a -f
    docker volume prune -f --all
    docker volume prune -f --all

clear-cargo-cache:
    cargo cache --autoclean

clear-rust-target-directories:
    # clear target directories
    fd Cargo.toml "$SRC_DIR" --exec rm -rf \{//\}/target
    # remove cargo cache
    rm -rf ~/.cargo/cache
    # remove custom toolchains
    rustup toolchain list | grep -v nightly-aarch64-apple-darwin | grep -v stable-aarch64-apple-darwin | xargs -n 1 rustup toolchain remove

clear-caches:
    rm -rf ~/Library/Caches/*
    rm -rf ~/Library/Developer/CoreSimulator/Caches/*
    rm -rf ~/.npm/_cacache
    rm -rf ~/.cache/

clear-dev-environments:
    fd --type d --no-ignore --hidden --prune "^\.direnv$" "$SRC_DIR" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "^\.venv$" "$SRC_DIR" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "^\.zed$" "$SRC_DIR" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "^\.ruff_cache$" "$SRC_DIR" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "^\.mypy_cache$" "$SRC_DIR" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "^\.terraform$" "$SRC_DIR" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "^\.tox$" "$SRC_DIR" --exec rm -rf {}
    fd --type d --no-ignore --prune node_modules "$SRC_DIR" --exec rm -rf {}

clear-docsrs-dev:
    fd --type d --no-ignore --hidden --prune "\.rustwide-docker" "$SRC_DIR/rust-lang/" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "\.workspaces" "$SRC_DIR/rust-lang/" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "\.workspace" "$SRC_DIR/rust-lang/" --exec rm -rf {}
    fd --type d --no-ignore --hidden --prune "ignored" "$SRC_DIR/rust-lang/" --exec rm -rf {}
