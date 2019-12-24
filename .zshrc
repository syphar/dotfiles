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

alias pcat="pygmentize -f terminal256 -O style=native -g"

# cd in one of my projects
cdp() {
  cd $(~/src/dotfiles/projects.py | selecta)
  clear
}

# open a file with vim
vims() {
  nvim $(ag . -i --nocolor --nogroup --hidden --ignore .git -g "" | selecta)
}

# open a file with vimR
vimrs() {
  vimr $(ag . -i --nocolor --nogroup --hidden --ignore .git -g "" | selecta)
}

# set HEROKU_APP environment based on the selected app
# cache the app-list once per day
setherokuapp() {
  today=$(date +"%Y_%m_%d")
  cache_filename=~/.cache/.heroku_apps_$today

  # if [ ! -f $cache_filename ]; then
  heroku apps --all --json | jq -r '. | map("\(.name)") | .[]' > $cache_filename
  # fi

  export HEROKU_APP=$(cat ${cache_filename} | selecta)
  echo "did set HEROKU_APP to $HEROKU_APP"
}

# checkout branches with fuzzy search, includes remote branches
gcos() {
  git checkout $(
	  (
		  # local branches
		  git for-each-ref --format='%(refname)' refs/heads/ | cut -c 12-999;
			# remote branches
		  git for-each-ref --format='%(refname)' refs/remotes/origin/ | cut -c 21-999;
	  ) | sort | uniq | selecta;
  )
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
