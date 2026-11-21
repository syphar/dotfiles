#!/usr/bin/env fish
set -l app $argv[1]

echo "resetting database credentials..."
heroku pg:credentials:rotate -a "$app" --confirm "$app"

for addon_name in (heroku redis:info -a "$app" --json | __get_only_name_from_json)
    echo "resetting redis credentials on $addon_name..."
    heroku redis:credentials --reset $addon_name -a "$app"
end
