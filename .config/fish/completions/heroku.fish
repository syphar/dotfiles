# extend default heroku completion:
# https://github.com/fish-shell/fish-shell/blob/master/share/completions/heroku.fish
# sometimes fixing behavior, sometimes caching/speed

function __fish_list_heroku_apps
    cat "$HOME/.cache/heroku_apps"
end


function __fish_heroku_using_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -gt 1
        if test $argv[1] = $cmd[2]
            return 0
        end
    end
    return 1
end

# add missing --app autocomplete for some commands
for cmd in 'logs' 'pg:psql'
    complete -c heroku -n "__fish_heroku_using_command $cmd" -s a -l app -xa '(__fish_list_heroku_apps)'
end
