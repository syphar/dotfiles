#!/usr/bin/env just --justfile

default:
  just --list

daily-update: 
    just heroku-login 
    update_cached_heroku_apps
    just update-homebrew
    just update-luarocks
    just update-pipx
    just update-generated-autocompletes
    just update-cached-pypi-package-list
    just update-rust
    just cargo-sweep
    just npm-upgrade
    just kill-mypyd
    just tldr-update

    ## bat cache
    bat cache --build

    just mackup
    just update-fish
    just update-vim

    just update-venv ~/src/neovim_env/venv/

    # github packages downloads
     ./download_github_release.sh marksman artempyanykh/marksman marksman-macos
     ./download_github_release.sh tuc riquito/tuc tuc-macos-amd64 

    # update tmux plugins
    ./find_repos.sh "$HOME/.tmux/plugins" | xargs -n 1 sh -c 'just update-git-repo $0 || exit 255'

    # update all source repos
    ./find_repos.sh ~/src/ | xargs -n 1 sh -c 'just update-git-repo $0 || exit 255'

    # update git worktrees
    ./find_worktrees.sh ~/src/ | xargs -n 1 sh -c 'just update-git-worktree $0 || exit 255'

update-generated-autocompletes:
    poetry completions fish > ~/.config/fish/completions/poetry.fish
    poe _fish_completion > ~/.config/fish/completions/poe.fish
    _DSLR_COMPLETE=fish_source dslr > ~/.config/fish/completions/dslr.fish

mackup:
    ## mackup
    mackup restore --force
    mackup backup
    # copy mackup files to dotfiles
    ./mackup_dotfiles.py

kill-mypyd:
    ## cleanup dmypy processes
    pkill -f dmypy || echo "nothing to kill"

tldr-update:
    ## tldr update
    tldr --update || echo "failed, but ignore for now"

heroku-login:
    ## heroku login, so we can fetch from heroku remotes later 
    heroku whoami || heroku login

update-homebrew:
    brew update && brew upgrade && brew upgrade --cask

    ## install missing packages
    brew bundle --no-upgrade --no-lock --quiet 1>/dev/null

    ## delete packages not in dump
    brew bundle cleanup -f

    ## cleanup
    brew cleanup -s


update-luarocks:
    ## luarocks packages
    xargs -n 1 luarocks install < luarocks_list.txt || echo "fail but OK"

    ## luarocks packages for lua 5.1, for neovim
    xargs -n 1 luarocks install --lua-version 5.1 < luarocks_list.txt || echo "fail but OK"

update-pipx:
    ## install/update pipx packages
    xargs -n 1 pipx install --include-deps < pipx_list.txt 1>/dev/null || echo "fail but OK"
    pipx reinstall-all
    pipx inject python-lsp-server pylsp-mypy rope
    pipx inject httpie httpie-ntlm
    pipx inject poetry poetry-dynamic-versioning
    pipx inject ipython rich requests
    pipx inject dslr psycopg2-binary


update-vim:
    nvim --headless \
        -c 'autocmd User PackerComplete quitall' \
        -c 'PackerSync'

    nvim --headless \
        -c "TSUpdateSync" \
        -c "quitall"

npm-upgrade: 
    #!/usr/bin/env bash
    set -euxo pipefail
    for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
    do
        npm -g install "$package"
    done

    xargs -n 1 npm install -g < global_npm_packages.txt 

cargo-sweep:
    # sweep rust target directory
    # we switch to any rust repo for cargo-sweep, 
    # but since we use a global target directory 
    # it clean up everything
    cd ~/src/rust-lang/docs.rs/ && \
        cargo sweep --time 30 && \
        cargo sweep --installed

update-cached-pypi-package-list:
    # regex /ggrep via https://unix.stackexchange.com/a/13472/388999
    curl --compressed -s "https://pypi.org/simple/" | ggrep -oP '(?<=/simple/)[^/]+(?=/)' > ~/.cache/pypi_packages.txt

update-rust:
    rustup update
    cargo install-update -a
    xargs -n 1 cargo install < cargo_install.txt || echo "fail but OK"

update-fish: clean-fish
    # update fisher
    fish -c "fisher update"

clean-fish:
    rm -f ~/.config/fish/fishd.tmp.*
    rm -f ~/.config/fish/fish_variables*conflicted*

update-venv VENV:
    {{VENV}}/bin/pip freeze | \
        grep = | \
        cut -d = -f 1 | \
        xargs {{VENV}}/bin/pip install -U

update-git-repo REPO:
    #!/bin/bash
    set -euo pipefail

    echo "#################################"
    echo "updating git repo: {{REPO}}"
    cd "{{REPO}}"

    ~/bin/rebuild_tags.sh

    if [ -f "{{REPO}}/.pre-commit-config.yaml" ]; then 
        if [ ! -f "{{REPO}}/.git/hooks/pre-commit" ]; then
            echo "pre-commit not found, installing..."
            pre-commit install
        else 
            echo "pre-commit found"
        fi
    fi

    if [ -f "{{REPO}}/.git-blame-ignore-revs" ]; then 
        git config blame.ignoreRevsFile .git-blame-ignore-revs
    fi

    ln -s $HOME/src/dotfiles/git-hooks/* "{{REPO}}/.git/hooks" || echo "already exists"

    git gc

    if [ -n "$(git remote)" ];
    then
        git fetch --all --recurse-submodules=yes --prune
        git fetch --all --prune --tags --force
        git merge --ff-only || echo "merge failed, but ok"
        git branch -v | grep "\[gone\]" | awk '{print {{REPO}}}' | xargs git branch -D || echo "failed, but ok"
    fi

update-git-worktree REPO:
    #!/bin/bash
    set -euo pipefail

    echo "#################################"
    echo "updating git worktree: {{REPO}}"

    cd "{{REPO}}"

    ~/bin/rebuild_tags.sh

    if [ -n "$(git remote)" ];
    then
        git merge --ff-only || echo "merge failed, but ok"
    fi
