alias gur="git fetch --all --recurse-submodules=yes --prune"

alias pipupgrade="pip freeze | grep = | cut -d = -f 1 | xargs pip install -U"
alias pipupgrade2="cat requirements.txt | grep = | cut -d = -f 1 | xargs pip install -U"
alias pipirt="pip install -r requirements_test.txt"

alias tiga='tig --all'
alias tigs='tig status'
alias gb='git branch -vv'
alias clippy='cargo clippy -Zunstable-options --verbose'

alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcs='docker compose'

alias vim="nvim"
alias vi="nvim"
abbr -ag da direnv allow
alias mux="teamocil"
alias agenda="watch --no-title --color --interval 120 gcalcli agenda --nodeclined --nostarted --details end"
alias tasks="watch --no-title --color --interval 1 task list"
alias n='vim -c "NV"'
abbr -ag h heroku
alias k9="kill -9"
abbr -ag gsh git show HEAD
abbr -ag gt git tag -n

alias l="exa -alh --group-directories-first"
alias ls="exa --group-directories-first"
alias less="bat"
alias cat="bat"
alias du="dust"
alias ps="procs"
alias top="ytop"
alias iftop="bandwhich"
alias objdump="bingrep"
alias hexdump="hx"
alias j="jobs"

abbr -ag g git
abbr -ag gco git checkout
abbr -ag gst git status
abbr -ag gc git commit
abbr -ag gs git stash
abbr -ag gsa git stash apply
abbr -ag gsc git stash clear

alias pr-create="gh pr create --fill --draft --assignee syphar"
alias pr-open="gh pr view --web"

alias unset 'set --erase'
