alias gur="git fetch --all --recurse-submodules=yes --prune"

alias pipupgrade="uv pip freeze | grep = | cut -d = -f 1 | xargs uv pip install -U"
alias pipupgrade2="cat requirements.txt | grep = | cut -d = -f 1 | xargs uv pip install -U"
alias pipirt="uv pip install --upgrade pip wheel setuptools && uv pip install -r requirements_test.txt"
abbr -ag pl poetry lock
abbr -ag pi poetry sync
abbr -ag pia poetry sync --all-extras

alias ta='tmux attach -t base || tmux new -s base'
alias tiga='tig --all'
alias tigs='tig status'
alias gb='git branch -vv'
alias gp='git push'
alias clippy='cargo clippy --all-features --all-targets --workspace --locked --fix --allow-dirty --allow-staged  -- -D warnings'
alias ssh='TERM=xterm-256color /usr/bin/ssh'

alias ranger='TERM=xterm-256color command ranger'

abbr -ag dcu docker compose up
abbr -ag dcd docker compose down
abbr -ag dcb docker compose build
abbr -ag dc docker compose
alias dcs="docker stop (docker ps -q)"

alias rc='ruff check --watch'
alias bf="butterfish"
alias vim="nvim"
alias vi="nvim"
abbr -ag da direnv allow
alias mux="teamocil"
alias agenda="watch --no-title --color --interval 120 gcalcli agenda --nodeclined --nostarted --details end"
alias tasks="watch --no-title --color --interval 1 task list"
alias n='vim -c "NV"'
alias k9="kill -9"
abbr -ag pg pgrep -f 
abbr -ag pk pkill -f 
abbr -ag gsh git show HEAD
abbr -ag gt git tag -n
abbr -ag gri git rebase -i
abbr -ag gra git rebase --abort
abbr -ag gr git rebase

abbr -ag tfp terraform plan
abbr -ag tfa terraform apply
abbr -ag tfi terraform init
abbr -ag tf terraform

abbr -ag h heroku
abbr -ag hl heroku login
alias heroku-shell "heroku run \"./manage.py shell\""

abbr -ag bcon bacon
abbr -ag bc bacon clippy-all
abbr -ag bt bacon test

alias ll="eza --long --all --header --icons --group-directories-first --color-scale=size --time-style=relative --git"
alias l="eza --icons --group-directories-first"
alias top="ytop"
alias iftop="bandwhich"
alias objdump="bingrep"
alias hexdump="hx"
alias hex="hexyl"
alias j="jobs"

abbr -ag lg gitui
abbr -ag g git
abbr -ag gco git checkout
abbr -ag gst git status
abbr -ag gc git commit
abbr -ag gcn git commit --no-verify
abbr -ag gs git stash
abbr -ag gsa git stash apply
abbr -ag gsp git stash pop
abbr -ag gsc git stash clear
abbr -ag grc git rebase --continue
abbr -ag grv git remote -v
abbr -ag c cargo
abbr -ag ct cargo nextest run
abbr -ag co cargo outdated --root-deps-only
abbr -ag cab cargo build
abbr -ag cac cargo check
abbr -ag sqlbat bat -l sql
abbr -ag hh http --verify=no --headers 
abbr -ag hb http --verify=no --print=hb
alias glo 'forgit::log -50'

alias cb='chatblade'

# common typos
abbr -ag dlsr dslr

alias prcreate="gh pr create --fill --draft --assignee syphar"
alias propen="gh pr view --web"
abbr -ag po propen
alias prcropen="gh pr create --fill --draft --assignee syphar && gh pr view --web"
abbr -ag pc prcropen

alias unset 'set --erase'
