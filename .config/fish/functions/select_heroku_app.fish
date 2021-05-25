function select_heroku_app
  set app (
    $HOME/bin/runcached \
      heroku apps --all --json | jq -r '. | map("\(.name)") | .[]' |
    fzf
  )
  commandline --current-token --replace -- $app
  commandline --function repaint
end
