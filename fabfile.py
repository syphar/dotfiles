#!/usr/bin/env python
# −*− coding: UTF−8 −*−

from fabric.api import local, lcd, execute, task
from fabric.colors import green

import pip


@task
def self_update():
    print(green('self_update'))
    local('git pull')


@task
def update_homebrew():
    print(green('update_homebrew'))
    local('brew update')
    local('brew upgrade')


@task
def update_zsh():
    print(green('update_zsh'))
    with lcd('~/.oh-my-zsh/'):
        local('git checkout master')
        local('git pull')


@task
def update_spf13():
    print(green('update_spf13'))
    with lcd('~/.spf13-vim-3/'):
        local('git checkout 3.0')
        local('git pull')
        local('vim +BundleInstall! +BundleClean +qa')


@task
def update_pip():
    print(green('update_pip'))

    for dist in pip.get_installed_distributions():
        local('pip install -U {}'.format(dist.project_name))


@task(default=True)
def update():
    execute(self_update)
    execute(update_homebrew)
    execute(update_zsh)
    execute(update_spf13)
    execute(update_pip)
