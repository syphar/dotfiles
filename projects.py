#! /usr/bin/env python3

import os
from pathlib import Path

SRC_DIR = os.path.join(os.path.expanduser("~"), "src")

PROJECT_SUB_DIRS = {".git", ".hg", ".svn", "venv", "target", "node_modules"}
PROJECT_SUB_FILES = {".envrc"}
PROJECT_SUB_FILES_RECURSE = {"Cargo.toml"}  # rust projects can have sub-projects


def yield_repos_in_folder(src_folder):
    for project, subdirs, subfiles in os.walk(src_folder):
        # for rust project we yield the project and recurse,
        # since we can have sub-crates
        if any(f in subfiles for f in PROJECT_SUB_FILES_RECURSE):
            yield project

            # TODO: use gitignore for this? or switch to FD?

            # don't recurse into hidden directories
            for sd in subdirs:
                if sd.startswith("."):
                    subdirs.remove(sd)

            # don't recurse into project trigger directories
            for to_delete in PROJECT_SUB_DIRS:
                try:
                    subdirs.remove(to_delete)
                except ValueError:
                    pass

        # directory based triggers for project
        elif any(f in subdirs for f in PROJECT_SUB_DIRS):
            yield project
            del subdirs[:]

        # other file based triggers for projects
        elif any(f in subfiles for f in PROJECT_SUB_FILES):
            yield project
            del subdirs[:]


def print_repos():
    for project in yield_repos_in_folder(SRC_DIR):
        print(project)

    # some hardcoded projects
    print(Path("~/.config/nvim/").expanduser())


if __name__ == "__main__":
    print_repos()
