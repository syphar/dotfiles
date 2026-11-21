function setherokuapp
    set --global -x HEROKU_APP (cat $HOME/.cache/heroku_apps | fzf)
    echo "did set HEROKU_APP to $HEROKU_APP"
end
