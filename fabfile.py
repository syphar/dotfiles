#!/usr/bin/env python
# −*− coding: UTF−8 −*−

import os

from fabric.api import local, lcd, execute, task, prefix, settings
from fabric.colors import green, blue, magenta, red

import pip


def self_update():
    print(green('self_update'))
    local('git pull')


def update_homebrew():
    print(green('update_homebrew'))
    local('brew update')
    local('brew upgrade')
    local('brew linkapps')


def update_zsh():
    print(green('update_zsh'))
    with lcd('~/.oh-my-zsh/'):
        local('git checkout master')
        local('git pull')


def update_spf13():
    print(green('update_spf13'))
    with lcd('~/.spf13-vim-3/'):
        local('git checkout 3.0')
        local('git pull')
        local('vim +BundleInstall! +BundleClean! +qa')


def update_pypi_cache():
    print(green('update_pypi_cache'))

    with prefix('/bin/bash -c "workon pep381"'):
        local('pep381run ~/data/pypi_cache/')


def update_pip():
    print(green('update_pip'))

    packages = [
        dist.project_name
        for dist in pip.get_installed_distributions()
        if dist.project_name not in ['git-remote-helpers']
    ]
    local('pip install -U {}'.format(' '.join(packages)))


@task
def update_repos():
    src_folder = os.path.join(os.path.expanduser('~'), 'src')

    for folder in os.listdir(src_folder):
        project = os.path.join(src_folder, folder)
        if not os.path.isdir(project):
            continue

        with lcd(project):
            print(blue('updating {}...'.format(folder)))

            with settings(warn_only=True):
                if os.path.exists(os.path.join(project, '.git')):
                    if len(local('git remote', capture=True)):
                        local('git fetch')
                        local('git fetch --tags')
                    else:
                        print(magenta('\tno remote configured'))

                elif os.path.exists(os.path.join(project, '.hg')):
                    local('hg pull')

                else:
                    print(red('\tno repo!'))


@task(default=True)
def update():
    execute(self_update)
    execute(update_homebrew)
    execute(update_zsh)
    execute(update_spf13)
    execute(update_pip)
    execute(update_repos)
