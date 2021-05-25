function insert_heroku_app
    commandline --current-token --replace -- (select_heroku_app)
    commandline --function repaint
end
