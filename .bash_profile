if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

[[ -s "/Users/syphar/.rvm/scripts/rvm" ]] && source "/Users/syphar/.rvm/scripts/rvm"

PATH=$PATH:/Users/syphar/pear/bin/
export PATH

export EDITOR="/usr/local/bin/mate -w"
export NODE_PATH="/usr/local/lib/node_modules"

export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.5.2.3/jars"
export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.3-45758/jars"

export EC2_URL="https://ec2.eu-west-1.amazonaws.com"


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#export PS1="\u@\h:\W #\! \A \`if [ \$? == 0 ]; then echo \:\); else echo \:\(; fi\` "
PROMPT_COMMAND='PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.\h: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"'

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export PROJECT_HOME=~/src/
export PIP_REQUIRE_VIRTUALENV=true
export PIP_VIRTUALENV_BASE=$WORKON_HOME

if [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
    source /usr/local/bin/virtualenvwrapper.sh
else
    source /usr/local/share/python/virtualenvwrapper.sh
fi

