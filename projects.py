#! /usr/bin/env python

import os

SRC_DIR = os.path.join(os.path.expanduser("~"), "src")


def yield_repos_in_folder(src_folder):
    for project, subdirs, subfiles in os.walk(src_folder):
        if ".git" in subdirs:
            yield project, "git"
            del subdirs[:]

        elif ".hg" in subdirs:
            yield project, "hg"
            del subdirs[:]

        elif ".svn" in subdirs:
            yield project, "svn"
            del subdirs[:]

        elif ".envrc" in subfiles:
            # elif ".direnv" in subdirs or ".envrc" in files:
            # non-vcs project
            yield project, ""
            del subdirs[:]


def print_repos():
    for project in get_all_repos():
        print(project)


def get_all_repos():
    return (project for project, kind in yield_repos_in_folder(SRC_DIR))


if __name__ == "__main__":
    print_repos()
