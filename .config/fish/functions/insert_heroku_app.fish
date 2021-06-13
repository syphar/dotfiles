function insert_heroku_app
    set app (select_heroku_app)
    commandline --current-token --replace -- "--app $app"
    commandline --function repaint
end
