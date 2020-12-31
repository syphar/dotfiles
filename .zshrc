# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
#

# uncomment for profiling
# zmodload zsh/zprof

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
# unsetopt correct_all

# share history across shells / panes..
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

alias gur="git fetch --all --recurse-submodules=yes --prune"

alias pipupgrade="pip freeze | grep = | cut -d = -f 1 | xargs pip install -U"
alias pipupgrade2="cat requirements.txt | grep = | cut -d = -f 1 | xargs pip install -U"
alias pipirt="pip install -r requirements_test.txt"

alias tiga='tig --all'
alias tigs='tig status'
alias gb='git branch -vv'
alias clippy='cargo clippy -Zunstable-options --verbose'


# cd in one of my projects
function cdp() {
  local dir
  dir=$(
  ~/src/dotfiles/find_projects.sh | fzf --tiebreak=end,index
  ) && cd $dir && clear
}

# open a file from this projects with vim
vv() {
  local file
  file=$(
    eval "$FZF_DEFAULT_COMMAND" |
    fzf
  ) && $EDITOR $file
}

# set HEROKU_APP environment based on the selected app
# cache the app-list once per day
setherokuapp() {
  local app
  app=$(
    heroku apps --all --json | jq -r '. | map("\(.name)") | .[]' |
    fzf
  ) && export HEROKU_APP=$app && echo "did set HEROKU_APP to $HEROKU_APP"
}

# fco - checkout git branch (including remote branches), sorted by most recent commit
# remote branches are checked out as a new local branch if they don't exist
fco() {
  local branches branch
  branches=$(git for-each-ref --sort=-committerdate refs/ --format="%(refname:short)") &&
  branch=$(
    echo "$branches" |
    fzf \
      --no-sort \
      --preview="git --no-pager branchdiff -150 '..{}'"
  ) &&
  git checkout $(echo "$branch" | sed "s/origin\///")
}

# checkout pull request
fpr() {
  local prs pr
  prs=$(hub pr list --format="%I|%t (%l)%n") &&
  pr=$(
    echo "$prs" |
      fzf \
        --delimiter="\|"  \
        --with-nth=2 \
        --preview="hub pr show {1} --format='%i %t%nlabels: %L%ncreated: %cr%nbranch: %H%nauthor: %au%nassigned: %as%nreview: %rs%n%n%b'"
  )  &&
  hub pr checkout $(echo "$pr" | cut -d "|" -f 1)
}

# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

# ftags - search ctags with preview
ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    fzf \
      --with-nth=2,3 \
  ) && ${EDITOR:-vim} $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"

}

PATH=~/bin:/usr/local/opt/ruby/bin:/usr/local/sbin:/usr/local/bin:$PATH
export PATH

eval "$(direnv hook zsh)"

alias vim="nvim"
alias vi="nvim"
alias da="direnv allow"
alias mux="teamocil"
alias agenda="watch --no-title --color --interval 120 gcalcli agenda --nodeclined --nostarted --details end"
alias tasks="watch --no-title --color --interval 1 task list"
alias n='vim -c "NV"'
alias h="heroku"
alias k9="kill -9"
alias gh="git show HEAD"
alias gt="git tag -n"

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
alias source_nvm="source /usr/local/opt/nvm/nvm.sh"


if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# working vi-mode for zsh
bindkey -v

# some jobs stuff
# forground last job
bindkey -s '^x' 'fg^M'
alias j="jobs"

# ctrl-p == `vv`, like search files in vim
bindkey -s '^p' 'vv^M'

# ctrl-o == `cdp`, goto project
bindkey -s '^o' 'cdp^M'

source ~/.p10k.zsh

fpath=(/usr/local/share/zsh-completions $fpath)

source ~/.fzf.zsh

# uncomment for profiling
# zprof
#

# vim: et ts=2 sts=2 sw=2
