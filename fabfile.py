#!/usr/bin/env python
# −*− coding: UTF−8 −*−

import os

import fabric
from fabric.api import local, lcd, execute, task, settings
from fabric.colors import green, blue, red, magenta

fabric.state.output.status = True
fabric.state.output.aborts = True
fabric.state.output.warnings = False
fabric.state.output.running = False
fabric.state.output.stdout = True
fabric.state.output.stderr = False
fabric.state.output.user = True


@task
def self_update():
    print(green('self_update'))
    local('git pull')


@task
def sync_omnifocus():
    print(green('update omnifocus github'))
    local('of sync')


@task
def update_homebrew():
    print(green('update_homebrew'))

    installed = set(local('brew list', capture=True).split())
    with open(os.path.join(os.path.expanduser('~'), 'src', 'dotfiles', 'brew_list.txt')) as brew_list:
        for brew in [b.strip() for b in brew_list]:
            if brew not in installed:
                with settings(warn_only=True):
                    local('brew install {}'.format(brew))

    local('brew update')
    local('brew upgrade')

    local('rm -f ~/Applications/*')
    local('brew linkapps')


@task
def cleanup_homebrew():
    print(green('cleanup_homebrew'))

    cache_folder = local('brew --cache', capture=True)
    local('rm -rf ' + cache_folder + "/*")

    local('brew cleanup --force')
    local('brew prune')

    for l in local('brew missing', capture=True).split('\n'):
        if not l:
            continue

        _, pkgs = l.strip().split(':')
        for p in pkgs.split():
            local('brew install ' + p)


@task
def update_zsh():
    print(green('update_zsh'))
    with lcd('~/.zprezto/'):
        local('git checkout master')
        local('git pull origin master')
        local('git pull upstream master')
        local('git push origin master')

    with lcd('~/.liquidprompt/'):
        local('git checkout develop')
        local('git fetch origin')
        local('git reset origin/develop')


@task
def update_vim():
    print(green('update_vim'))
    local('/Applications/MacVim.app/Contents/MacOS/Vim +BundleInstall! +BundleClean! +qa')

    with lcd('~/.vim/bundle/YouCompleteMe'):
        local('./install.sh')


def update_brew_list():
    print(green('update_brew_list'))
    listfile = os.path.expanduser('~/src/dotfiles/brew_list.txt')
    local('brew list >> {}'.format(listfile))
    local('sort {0} | uniq > {0}.tmp'.format(listfile))
    os.remove(listfile)
    os.rename('{}.tmp'.format(listfile), listfile)
    with lcd('~/src/dotfiles/'):
        with settings(warn_only=True):
            local('git add brew_list.txt')
            local("git commit -m 'new brews'")


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
            return True
        else:
            print(magenta('\tno remote configured'))
            return False


def git_merge_ff(repo, branch, commit):
    """Merge a branch without checking it out"""
    with lcd(repo):
        branch_ref = 'refs/heads/{0}'.format(branch)
        branch_orig_hash = local('git show-ref -s --verify {0}'.format(branch_ref), capture=True)
        commit_orig_hash = local('git rev-parse --verify {0}'.format(commit), capture=True)

        if local('git symbolic-ref HEAD', capture=True) == branch_ref:
            local('git merge --ff-only "{0}"'.format(commit))

        else:
            if local("git merge-base {}  {}".format(branch_orig_hash, commit_orig_hash), capture=True) != branch_orig_hash:
                print(red('merging {0} into {1} would not be a fast-forward'.format(commit, branch)))

            else:
                print(green("Updating {}..{}".format(branch, commit)))

                local('git update-ref -m "merge {0}: Fast forward" "{1}" "{2}" "{3}"'.format(commit, branch_ref, commit_orig_hash, branch_orig_hash))
                with settings(warn_only=True):
                    local('git diff --shortstat "{0}@{{1}}" "{0}"'.format(branch))


def git_rebase_branches(repo):
    with lcd(repo):
        remotes = set(b[20:] for b in local("git for-each-ref --format='%(refname)' refs/remotes/origin/", capture=True).split('\n') if len(b) > 21)
        for ref in local("git for-each-ref --format='%(refname)' refs/heads/", capture=True).split('\n'):
            branch = ref[11:]
            if branch in remotes:
                git_merge_ff(repo, branch, "origin/{}".format(branch))


def hg_pull(repo):
    with lcd(repo):
        local('hg pull')


def svn_up(repo):
    with lcd(repo):
        local('svn update')


def update_repos_in_folder(src_folder):
    for folder in os.listdir(src_folder):
        project = os.path.join(src_folder, folder)
        if not os.path.isdir(project):
            continue

        with settings(warn_only=True):
            if os.path.exists(os.path.join(project, '.git')):
                print(blue('updating {}...'.format(project)))
                if git_fetch(project):
                    git_rebase_branches(project)
                git_update_hooks(project)

            elif os.path.exists(os.path.join(project, '.hg')):
                print(blue('updating {}...'.format(project)))
                hg_pull(project)

            elif os.path.exists(os.path.join(project, '.svn')):
                print(blue('updating {}...'.format(project)))
                svn_up(project)

            else:
                update_repos_in_folder(project)


@task
def update_repos():
    update_repos_in_folder(
        os.path.join(os.path.expanduser('~'), 'src')
    )


@task(default=True)
def update():
    execute(self_update)
    execute(sync_omnifocus)
    execute(update_homebrew)
    execute(update_zsh)
    execute(update_vim)
    execute(update_repos)
    execute(update_brew_list)
