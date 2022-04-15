# heroku CLI completion, 
# based on the bash/zsh completion included in the CLI, 
# and the broken fish-builtin heroku-cli completion.

# file with all possible commands & long arguments. 
# I don't know yet how this is generated.
set -l heroku_ac_commands_path $HOME/Library/Caches/heroku/autocomplete/commands

function __fish_heroku_using_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -gt 1
        if test $argv[1] = $cmd[2]
            return 0
        end
    end
    return 1
end

function __fish_heroku_needs_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

function __list_heroku_complete_options
    set -l cmd (commandline -opc)
    # for now cache all autocomplete options 
    # I locally I couldn't make the command return anything except app-names, 
    # even though there seems to be logic to complete addon-names. 
    # We might have to remove the cache, or make it include PWD or ENV in the 
    # cache-key
    ~/bin/runcached --ignore-pwd --ignore-env \
        -- heroku autocomplete:options "$cmd"
end

function __get_only_name_from_json
    jq -r '. | map("\(.name)") | .[]'
end

function __fish_list_installed_addons
    # TODO: fetch --app from other args or HEROKU_APP and use to fetch the correct app-addons 
    ~/bin/runcached \
        -- heroku addons --json | __get_only_name_from_json
end

set -l heroku_looking -c heroku -n __fish_heroku_needs_command

for line in (/bin/cat $heroku_ac_commands_path)
    set -l tokens (string split --no-empty ' ' $line)
    set -l cmd $tokens[1]

    complete $heroku_looking -xa $cmd

    for token in $tokens
        if test $token != $cmd
            set -l long_arg (echo "$token" | string sub --start 3)

            if test $long_arg = 'app' 
                # special case to add short `-a` arg for `--app` for now
                complete -c heroku -n "__fish_heroku_using_command $cmd" -s a -l app -xa '(__list_heroku_complete_options)'
            else
                complete -c heroku -n "__fish_heroku_using_command $cmd" -l $long_arg -xa '(__list_heroku_complete_options)'
            end
        end
    end
end

# additional completions that don't seem to work with autocomplete:options
for cmd in 'addons:destroy' 'addons:info'
    complete -c heroku -n "__fish_heroku_using_command $cmd" -fa '(__fish_list_installed_addons)'
end
