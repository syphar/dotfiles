function select_heroku_app
    $HOME/bin/runcached \
      heroku apps --all --json | jq -r '. | map("\(.name)") | .[]' |
      fzf
end
