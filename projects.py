#! /usr/bin/env python

import os

SRC_DIR = os.path.join(os.path.expanduser('~'), 'src')
REPO_CACHE = os.path.join(os.path.expanduser("~"), '.cache', '.project_list')


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
    if not os.path.exists(REPO_CACHE):
        update_repo_cache()

    with open(REPO_CACHE) as f:
        print(f.read())


def update_repo_cache():
    content = '\n'.join(
        repo
        for repo, kind in yield_repos_in_folder(SRC_DIR)
    )

    if os.path.exists(REPO_CACHE):
        os.remove(REPO_CACHE)

    with open(REPO_CACHE, 'w') as f:
        f.write(content)


def get_all_repos():
    return (
        project 
        for project, kind in yield_repos_in_folder(SRC_DIR)
    )


if __name__ == '__main__':
    print_repos()
