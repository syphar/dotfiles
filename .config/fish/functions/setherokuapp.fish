function setherokuapp
    set --global -x HEROKU_APP (select_heroku_app)
    echo "did set HEROKU_APP to $HEROKU_APP"
end
