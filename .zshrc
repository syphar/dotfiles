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

alias gur="git fetch --all --recurse-submodules=yes --prune"

alias pipupgrade="pip freeze | grep = | cut -d = -f 1 | xargs pip install -U"
alias pipupgrade2="cat requirements.txt | grep = | cut -d = -f 1 | xargs pip install -U"

alias tiga='tig --all'
alias tigs='tig status'

# cd in one of my projects
cdp() {
  local dir
	dir=$(
    ~/src/dotfiles/projects.py | fzf --preview 'ls -1 {} | head -$LINES'
  ) && cd $dir && clear
}

# open a file with vim
vims() {
  local file
	file=$(
	  ag . -i --nocolor --nogroup --hidden --ignore .git -g "" |
    fzf --preview 'bat --style=numbers --color=always {} | head -$LINES'
  ) && nvim $file
}

# open a file with vimR
vimrs() {
  local file
	file=$(
	  ag . -i --nocolor --nogroup --hidden --ignore .git -g "" |
    fzf --preview 'bat --style=numbers --color=always {} | head -$LINES'
  ) && vimr $file
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

# checkout branches with fuzzy search, includes remote branches
gcos() {
  local branch
	branch=$(
	  (
		  # local branches
		  git for-each-ref --format='%(refname)' refs/heads/ | cut -c 12-999;
			# remote branches
		  git for-each-ref --format='%(refname)' refs/remotes/origin/ | cut -c 21-999;
	  ) | sort | uniq | fzf;
  ) && git checkout $branch
}

# ftags - search ctags
ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    cut -c1-80 | fzf --nth=1,2
  ) && ${EDITOR:-vim} $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}


PATH=~/bin:/usr/local/opt/ruby/bin:/usr/local/sbin:/usr/local/bin:$PATH
export PATH

# very simple prompt, only folder name and %
# rest is shown in iterm status bar
export PROMPT="[%1~] %# "

eval "$(direnv hook zsh)"

alias vim="nvim"
alias vi="nvim"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

iterm2_print_user_vars() {
  iterm2_set_user_var herokuApp $HEROKU_APP
  iterm2_set_user_var virtualEnv ${VIRTUAL_ENV##*/}
}

# uncomment for profiling
# zprof
#

# vim: set tabstop=2:shiftwidth=2:expandtab
