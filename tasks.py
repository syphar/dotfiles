#!/usr/bin/env python
import os

# import fabric
# from fabric.api import local, lcd, execute, task, settings
# from fabric.colors import green, blue, red, magenta
from invoke import task

from projects import SRC_DIR, yield_repos_in_folder, update_repo_cache


# fabric.state.output.status = True
# fabric.state.output.aborts = True
# fabric.state.output.warnings = False
# fabric.state.output.running = False
# fabric.state.output.stdout = True
# fabric.state.output.stderr = False
# fabric.state.output.user = True
#

@task
def self_update(ctx):
    print(print('self_update'))
    ctx.run('git pull')


@task
def update_homebrew(ctx):
    print(print('update_homebrew'))

    installed = set(ctx.run('brew list', capture=True).split())
    with open(os.path.join(os.path.expanduser('~'), 'src', 'dotfiles', 'brew_list.txt')) as brew_list:
        for brew in [b.strip() for b in brew_list]:
            if brew not in installed:
                ctx.run('brew install {}'.format(brew), warn=True)

    ctx.run('brew update')
    ctx.run('brew upgrade')


@task
def cleanup_homebrew(ctx):
    print(print('cleanup_homebrew'))

    cache_folder = ctx.run('brew --cache', capture=True)
    ctx.run('rm -rf ' + cache_folder + "/*")

    ctx.run('brew cleanup --force')
    ctx.run('brew prune')

    for l in ctx.run('brew missing', capture=True).split('\n'):
        if not l:
            continue

        _, pkgs = l.strip().split(':')
        for p in pkgs.split():
            ctx.run('brew install ' + p)


@task
def update_zsh(ctx):
    print(print('update_zsh'))
    with ctx.cd('~/.zprezto/'):
        ctx.run('git pull')
        ctx.run('git submodule update --init --recursive')

    with ctx.cd('~/.liquidprompt/'):
        ctx.run('git checkout master')
        ctx.run('git fetch origin')
        ctx.run('git reset origin/master')


def update_brew_list(ctx):
    print(print('update_brew_list'))
    listfile = os.path.expanduser('~/src/dotfiles/brew_list.txt')
    ctx.run('brew list >> {}'.format(listfile))
    ctx.run('sort {0} | uniq > {0}.tmp'.format(listfile))
    os.remove(listfile)
    os.rename('{}.tmp'.format(listfile), listfile)
    with lcd('~/src/dotfiles/'):
        ctx.run('git add brew_list.txt', warn=True)
        ctx.run("git commit -m 'new brews'", warn=True)


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
        if len(ctx.run('git remote', capture=True)):
            ctx.run('git fetch --all --recurse-submodules=yes --prune')
            ctx.run('git fetch --all --recurse-submodules=yes --prune --tags')
            return True
        else:
            print(magenta('\tno remote configured'))
            return False


def git_merge_ff(repo, branch, commit):
    """Merge a branch without checking it out"""
    with lcd(repo):
        branch_ref = 'refs/heads/{0}'.format(branch)
        branch_orig_hash = ctx.run('git show-ref -s --verify {0}'.format(branch_ref), capture=True)
        commit_orig_hash = ctx.run('git rev-parse --verify {0}'.format(commit), capture=True)

        if ctx.run('git symbolic-ref HEAD', capture=True) == branch_ref:
            ctx.run('git merge --ff-only "{0}"'.format(commit))

        else:
            if ctx.run("git merge-base {}  {}".format(branch_orig_hash, commit_orig_hash),
                     capture=True) != branch_orig_hash:
                print(red('merging {0} into {1} would not be a fast-forward'.format(commit, branch)))

            else:
                print(print("Updating {}..{}".format(branch, commit)))

                ctx.run('git update-ref -m "merge {0}: Fast forward" "{1}" "{2}" "{3}"'.format(commit, branch_ref,
                                                                                             commit_orig_hash,
                                                                                             branch_orig_hash))
                with settings(warn_only=True):
                    ctx.run('git diff --shortstat "{0}@{{1}}" "{0}"'.format(branch))


def git_rebase_branches(repo):
    with lcd(repo):
        remotes = set(b[20:] for b in
                      ctx.run("git for-each-ref --format='%(refname)' refs/remotes/origin/", capture=True).split('\n') if
                      len(b) > 21)
        for ref in ctx.run("git for-each-ref --format='%(refname)' refs/heads/", capture=True).split('\n'):
            branch = ref[11:]
            if branch in remotes:
                git_merge_ff(repo, branch, "origin/{}".format(branch))


def git_cleanup(repo):
    with lcd(repo):
        ctx.run('git gc --auto')


def hg_pull(repo):
    with lcd(repo):
        ctx.run('hg pull')


def svn_up(repo):
    with lcd(repo):
        ctx.run('svn update')


def update_repo(project, kind):
    with settings(warn_only=True):
        if kind == 'git':
            print(blue('updating {}...'.format(project)))
            if git_fetch(project):
                git_rebase_branches(project)
            git_update_hooks(project)
            git_cleanup(project)

        elif kind == 'hg':
            print(blue('updating {}...'.format(project)))
            hg_pull(project)

        elif kind == 'svn':
            print(blue('updating {}...'.format(project)))
            svn_up(project)


@task
def update_repos(ctx):
    for repo, kind in yield_repos_in_folder(SRC_DIR):
        update_repo(repo, kind)


@task
def update_vim(ctx):
    print(print('update_vim'))
    ctx.run('vim "+call dein#update()" +qa')


@task
def new_repo_cache(ctx):
    print(print('clean local project cache'))
    ctx.run('rm -rf ~/.cache/.project_list')


@task
def rustup(ctx):
    print(print('update rustup'))
    ctx.run('rustup update')


@task(default=True)
def update(ctx):
    execute(self_update)
    execute(update_homebrew)
    execute(update_zsh)
    execute(update_repo_cache)
    execute(rustup)
    execute(update_repos)
    execute(update_brew_list)
    execute(update_vim)
    execute(new_repo_cache)
