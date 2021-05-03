# set HEROKU_APP environment based on the selected app
# cache the app-list once per day
function setherokuapp
  set app (
    $HOME/bin/runcached \
      heroku apps --all --json | jq -r '. | map("\(.name)") | .[]' |
    fzf
  )
  export HEROKU_APP=$app
  echo "did set HEROKU_APP to $HEROKU_APP"
end
