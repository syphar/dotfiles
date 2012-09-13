#!/usr/bin/env python
# −*− coding: UTF−8 −*−

from fabric.api import local, lcd, execute, task, prefix
from fabric.colors import green

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


@task(default=True)
def update():
    execute(self_update)
    execute(update_homebrew)
    execute(update_zsh)
    execute(update_spf13)
    execute(update_pip)
