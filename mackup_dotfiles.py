#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#     "mackup",
#     "defusedxml",
#     "requests"
# ]
# ///

from pathlib import Path

from mackup import appsdb, utils

app_list = (
    "bat",
    "ctags",
    "ctags_dir",
    "direnv",
    "fd",
    "ghostty",
    "git",
    "gitignore-global",
    "httpie",
    "kitty",
    "lsd",
    "mackup",
    "mybin",
    "mycargo",
    "myfish",
    "myhttpie",
    "myneovim",
    "mytmuxinator",
    "pgsql",
    "ranger",
    "starship",
    "tmate",
    "tmux",
    "tmuxinator",
)

destination_folder = Path(__file__).parent


apps_db = appsdb.ApplicationsDatabase()
for app_name in app_list:
    print(f"copy application config for {app_name}...")

    files_ = apps_db.get_files(app_name)

    for file_ in files_:
        source = Path("~").expanduser() / file_
        destination = destination_folder / file_

        if not source.exists():
            continue

        if destination.exists():
            utils.delete(str(destination))

        utils.copy(str(source), str(destination))
