#! /usr/bin/env python

import os

SRC_DIR = os.path.join(os.path.expanduser('~'), 'src')


def yield_repos_in_folder(src_folder):
    for project, subdirs, _ in os.walk(src_folder):
        if '.git' in subdirs:
            yield project, 'git'
            del subdirs[:]

        elif '.hg' in subdirs:
            yield project, 'hg'
            del subdirs[:]

        elif '.svn' in subdirs:
            yield project, 'svn'
            del subdirs[:]


def print_repos():
    for repo, kind in yield_repos_in_folder(SRC_DIR):
        print(repo)


if __name__ == '__main__':
    print_repos()
