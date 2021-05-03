#!/usr/bin/env python
from pathlib import Path
from mackup import utils, appsdb

app_list = (
    "alacritty",
    "bat",
    "ctags",
    "ctags_dir",
    "direnv",
    "fd",
    "git",
    "mackup",
    "mybin",
    "myfish",
    "myneovim",
    "mytmuxinator",
    "pgsql",
    "powerlevel10k",
    "prezto",
    "ranger",
    "tmate",
    "tmux",
    "tmuxinator",
    "zsh",
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
