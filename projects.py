#! /usr/bin/env python

import os

SRC_DIR = os.path.join(os.path.expanduser('~'), 'src')


def yield_repos_in_folder(src_folder):
    for folder in os.listdir(src_folder):
        project = os.path.join(src_folder, folder)
        if not os.path.isdir(project):
            continue

        if os.path.exists(os.path.join(project, '.git')):
            yield project, 'git'

        elif os.path.exists(os.path.join(project, '.hg')):
            yield project, 'hg'

        elif os.path.exists(os.path.join(project, '.svn')):
            yield project, 'svn'

        else:
            for repo, kind in yield_repos_in_folder(project):
                yield repo, kind


def print_repos():
    for repo, kind in yield_repos_in_folder(SRC_DIR):
        print(repo)


if __name__ == '__main__':
    print_repos()
