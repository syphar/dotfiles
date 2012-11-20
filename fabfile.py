#!/usr/bin/env python
# −*− coding: UTF−8 −*−

import os

import fabric
from fabric.api import local, lcd, execute, task, settings
from fabric.colors import green, blue, red, magenta
from fabric.context_managers import shell_env

import pip

fabric.state.output.status = True
fabric.state.output.aborts = True
fabric.state.output.warnings = False
fabric.state.output.running = False
fabric.state.output.stdout = True
fabric.state.output.stderr = False
fabric.state.output.user = True


def self_update():
    print(green('self_update'))
    local('git pull')


def update_homebrew():
    print(green('update_homebrew'))
    local('brew update')
    local('brew upgrade')

    local('rm -f ~/Applications/*')
    local('brew linkapps')


def update_zsh():
    print(green('update_zsh'))
    with lcd('~/.oh-my-zsh/'):
        local('git checkout master')
        local('git pull origin master')
        local('git pull upstream master')
        local('git push origin master')


def update_spf13():
    print(green('update_spf13'))
    with lcd('~/.spf13-vim-3/'):
        local('git checkout 3.0')
        local('git pull')
        local('vim +BundleInstall! +BundleClean! +qa')


def update_pip():
    print(green('update_pip'))

    packages = [
        dist.project_name
        for dist in pip.get_installed_distributions()
        if dist.project_name not in ['git-remote-helpers']
    ]

    with shell_env(PIP_REQUIRE_VIRTUALENV="false"):
        local('pip install -U {}'.format(' '.join(packages)))


def git_update_hooks(repo):
    git_dir = os.path.join(repo, '.git')

    if not os.path.exists(git_dir):
        return

    hook_dir = os.path.join(git_dir, 'hooks')

    if not os.path.exists(hook_dir):
        os.mkdir(hook_dir)

    local_hooks = os.path.join(os.path.dirname(__file__), 'git-hooks')

    for hook in os.listdir(local_hooks):
        print('{}-hook'.format(hook))

        hook_source = os.path.join(local_hooks, hook)
        hook_dest = os.path.join(hook_dir, hook)

        if os.path.lexists(hook_dest):
            os.remove(hook_dest)

        os.symlink(hook_source, hook_dest)


def git_fetch(repo):
    with lcd(repo):
        if len(local('git remote', capture=True)):
            local('git fetch --all --recurse-submodules=yes --prune')
            local('git fetch --all --recurse-submodules=yes --prune --tags')
        else:
            print(magenta('\tno remote configured'))


def hg_pull(repo):
    with lcd(repo):
        local('hg pull')


def svn_up(repo):
    with lcd(repo):
        local('svn update')


@task
def update_repos():
    src_folder = os.path.join(os.path.expanduser('~'), 'src')

    for folder in os.listdir(src_folder):
        project = os.path.join(src_folder, folder)
        if not os.path.isdir(project):
            continue

        print(blue('updating {}...'.format(folder)))

        with settings(warn_only=True):
            if os.path.exists(os.path.join(project, '.git')):
                git_fetch(project)
                git_update_hooks(project)

            elif os.path.exists(os.path.join(project, '.hg')):
                hg_pull(project)

            elif os.path.exists(os.path.join(project, '.svn')):
                svn_up(project)

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
