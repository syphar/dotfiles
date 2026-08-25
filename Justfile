#!/usr/bin/env just --justfile

set unstable
set working-directory := '/home/syphar/src/dotfiles'

export HOME := "/home/syphar"
export SRC_DIR := HOME / "src"
export TMP_DIR := HOME / "tmp"

JAEGER_VERSION := "2.19.0"

default:
    just --list

daily-update:
    git pull # to allow SSH key access in 1p, once, so later steps can use it
    # just heroku-cli
    # # update_cached_heroku_apps
    just update-system
    just update-luarocks
    just update-python-tools
    just update-generated-autocompletes
    just update-cached-pypi-package-list
    just update-rust
    just update-go
    just npm-upgrade
    just prune-zoxide

    just clear-disk-space-daily

    gh extension upgrade --all

    bat cache --build

    just mackup
    just update-fish
    just update-vim

    # github packages downloads
    ./download_github_release.sh tuc riquito/tuc tuc-ubuntu-amd64

    # update tmux plugins
    ./find_repos.sh "$HOME/.tmux/plugins" | xargs -n 1 sh -c 'just update-git-repo $0 || exit 255'

    (cd "$SRC_DIR/rust-lang/docs.rs" && clean-git-remotes origin upstream guillaumegomez)

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
    # convert into new config files to links,
    # or any newly supported files after the mackup upgrade
    mackup link install --force-no

    # add local links based on new remote files
    mackup link

    # copy some configs to dotfiles, to share
    ./mackup_dotfiles.py

heroku-cli:
    ## heroku login, so we can fetch from heroku remotes later
    heroku whoami || heroku login
    ## update the Heroku CLI
    heroku update
    ## try to update the autocomplete cache
    heroku autocomplete zsh

update-system:
    sudo dnf upgrade --refresh -y
    flatpak update -y
    mise upgrade

backup-package-list: 
    dnf repoquery --userinstalled --qf '%{name}\n' | sort -u > /data/backup/packages/packages-rpm.txt
    flatpak list --app --columns=application > /data/backup/packages/packages-flatpak.txt
    dnf repolist --enabled > /data/backup/packages/repos.txt

update-go:
    #!/usr/bin/env bash

    # update binaries installed with `go install`
    for bin in "$(go env GOPATH)"/bin/*; do
        pkg=$(go version -m "$bin" | awk '$1 == "path" { print $2 }')
        echo "updating go $pkg to latest version"
        go install "$pkg@latest"
    done

update-luarocks:
    ## luarocks packages
    -xargs -n 1 luarocks install --local < luarocks_list.txt

    ## luarocks packages for lua 5.1, for neovim
    -xargs -n 1 luarocks install --local --lua-version 5.1 < luarocks_list.txt

update-python-tools:
    #!/usr/bin/env nu

    open ./uv_tool_list.txt
    | lines
    | each { |line| $line | str trim }
    | where ($it | is-not-empty) and (not ($it | str starts-with "#"))
    | each { |pkg|
        print "========================"
        print $"installing/updating: ($pkg)"
        uv tool install --upgrade ...($pkg | split row " ")
    }
    | ignore

update-vim:
    rm -f ~/.local/state/nvim/*.log
    rm -f ~/.config/nvim/.nvimlog
    rm -f ~/.config/nvim/*.log

    nvim --headless '+Lazy! sync' +qa

npm-upgrade:
    #!/usr/bin/env bash
    set -euxo pipefail
    for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
    do
        npm -g install "$package"
    done

    xargs -n 1 npm install -g < global_npm_packages.txt

cargo-sweep-global:
    #!/bin/bash
    set -euo pipefail

    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    cd "$tmpdir"

    cargo init --name "some"
    just --justfile "{{ justfile() }}" cargo-sweep "$tmpdir"

cargo-sweep REPO:
    cd {{ REPO }} && \
        cargo sweep --time 30 && \
        cargo sweep --installed

update-cached-pypi-package-list:
    # regex /grep via https://unix.stackexchange.com/a/13472/388999
    curl --compressed -s "https://pypi.org/simple/" | grep -oP '(?<=/simple/)[^/]+(?=/)' > ~/.cache/pypi_packages.txt

update-rust: && build-docs-rs-mcp
    rustup update
    cargo install-update -a
    rm -f ~/.cargo/bin/rust-analyzer
    -/bin/cat cargo_install.txt | tr '\n' '\0' | xargs -0 -n1 cargo binstall
    ensure_rustup_components_for_installed_toolchains.sh
    rustup override unset --nonexistent

[working-directory('/home/syphar/src/rust-lang/docs-rs-mcp')]
build-docs-rs-mcp:
    #!/usr/bin/env bash

    if [ -n "$(git status --porcelain)" ]; then
      echo "unclean worktree"
      exit 1
    fi

    git checkout main
    git ff
    cargo build --release

prune-zoxide:
    #!/usr/bin/env nu

    ^zoxide query --list --all
    | lines
    | where { |path| not ($path | path exists) }
    | each { |path|
        ^zoxide remove $path
    }
    | ignore

update-fish: clean-fish
    # update fisher
    fish -c "fisher update"

clean-fish:
    rm -f ~/.config/fish/fishd.tmp.*
    rm -f ~/.config/fish/fish_variables*conflicted*

install-custom-rust-binary REPO BINARY_NAME BUILD_ARGS="":
    cd {{ REPO }} && cargo build --release {{ BUILD_ARGS }}

    rm -f $HOME/bin/{{ BINARY_NAME }}
    mv {{ REPO }}/target/release/{{ BINARY_NAME }} $HOME/bin/{{ BINARY_NAME }}

update-git-repo REPO:
    #!/bin/bash
    set -euo pipefail

    echo "updating {{ REPO }}"

    if [ -e "{{ REPO }}/Cargo.toml" ]; then
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

link-docsrs-agents:
    #!/usr/bin/env nu

    let root = ($env.HOME | path join "src" "rust-lang" "docs.rs")
    let source = ($env.HOME | path join "Dropbox" "rust-lang" "docs-rs" "AGENTS.md")

    ^git -C $root worktree list --porcelain
    | lines
    | where ($it | str starts-with "worktree ")
    | each { |line|
        let wt = ($line | str replace "worktree " "")
        let dest = ($wt | path join "AGENTS.md")

        ^rm -f $dest
        ^ln -s $source $dest
        print $"Linked: ($dest) -> ($source)"
    }
    | ignore

clear-dropbox-cache:
    rm -rf ~/Dropbox/.dropbox.cache/*

clear-disk-space-daily:
    just clear-docker-daily
    just clean-tmp

clean-tmp:
    # Delete only top-level entries that have not been modified in seven days.
    fd --hidden --no-ignore --max-depth 1 --changed-before 7d . "$TMP_DIR" --exec-batch rm -rf --
    fd --hidden --no-ignore --max-depth 1 --changed-before 7d . "$HOME/Downloads/" --exec-batch rm -rf --

clear-disk-space:
    just clear-dropbox-cache
    just clear-logs
    just clear-docker
    just clear-cargo-cache
    just clear-go-caches
    just clear-dev-environments
    just clear-caches
    just clear-rust-target-directories {{ SRC_DIR }}
    just clear-rust-target-directories {{ TMP_DIR }}
    just clear-rust-disk-space
    just clear-docsrs-dev
    just garbage-collect-git-repos

clear-go-caches:
    go clean -cache
    go clean -testcache
    go clean -modcache
    go clean -fuzzcache

clear-logs:
    rm -rf /usr/local/var/log/*
    rm -rf ~/.local/state/nvim/lsp.log

clear-docker-daily:
    # only dangling things
    docker image prune -f
    docker builder prune -f
    docker volume prune -f

clear-docker:
    docker container prune -f
    docker image prune -a -f
    docker builder prune -a -f
    docker volume prune -f --all
    docker volume prune -f --all

clear-cargo-cache:
    cargo cache --autoclean

clear-rust-disk-space:
    # remove shared cargo target dir
    rm -rf ~/.cache/cargo-target/
    # remove cargo cache
    rm -rf ~/.cargo/cache
    # remove custom toolchains
    rustup toolchain list | grep -v nightly-aarch64-apple-darwin | grep -v stable-aarch64-apple-darwin | xargs -n 1 rustup toolchain remove

clear-rust-target-directories dir=SRC_DIR:
    # clear target directories
    fd Cargo.toml "{{ dir }}" --exec rm -rf \{//\}/target

clear-caches:
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

get-all-crates:
    git -C /data/crates.io-index/ pull
    get-all-crates --index /data/crates.io-index/ --out /data/crates/ --latest -j 8

gvisor-install:
    #!/usr/bin/env bash
    set -euxo pipefail

    ARCH=$(uname -m)
    URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH}
    wget ${URL}/gvisor.tar.bz2 ${URL}/gvisor.tar.bz2.sha512
    sha512sum -c gvisor.tar.bz2.sha512
    sudo tar -xjf gvisor.tar.bz2 -C /usr/local/bin
    rm -f gvisor.tar.bz2 gvisor.tar.bz2.sha512

gvisor-register:
  sudo /usr/local/bin/runsc install
  sudo systemctl reload docker
  docker run --rm --runtime=runsc hello-world

gvisor-test:
  docker run --rm --runtime=runsc hello-world
