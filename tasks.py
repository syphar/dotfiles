#!/usr/bin/env python
import os
from pathlib import Path

from invoke import task

from projects import SRC_DIR, yield_repos_in_folder, update_repo_cache, get_all_repos


@task
def self_update(ctx):
    print('self_update')
    ctx.run('git pull')


@task
def update_homebrew(ctx):
    print('update_homebrew')

    installed = set(ctx.run('brew list', hide='out').stdout.split())
    with open(os.path.join(os.path.expanduser('~'), 'src', 'dotfiles', 'brew_list.txt')) as brew_list:
        for brew in [b.strip() for b in brew_list]:
            if brew not in installed:
                ctx.run('brew install {}'.format(brew), warn=True)

    ctx.run('brew update')
    ctx.run('brew upgrade')


@task
def cleanup_homebrew(ctx):
    print('cleanup_homebrew')

    cache_folder = ctx.run('brew --cache').stdout

    ctx.run('brew cleanup')
    ctx.run('brew prune')

    for l in ctx.run('brew missing').stdout.split('\n'):
        if not l:
            continue

        _, pkgs = l.strip().split(':')
        for p in pkgs.split():
            ctx.run('brew install ' + p)


@task
def update_zsh(ctx):
    print('update_zsh')
    with ctx.cd('~/.zprezto/'):
        ctx.run('git fetch --all --prune')
        ctx.run('git merge origin/master --ff-only', warn=True)
        ctx.run('git merge upstream/master', warn=True)
        ctx.run('git submodule update --init --recursive')
        ctx.run('git push')

    with ctx.cd('~/.liquidprompt/'):
        ctx.run('git checkout master')
        ctx.run('git fetch origin')
        ctx.run('git reset origin/master')


@task
def update_brew_list(ctx):
    print('update_brew_list')
    listfile = os.path.expanduser('~/src/dotfiles/brew_list.txt')
    ctx.run('brew list >> {}'.format(listfile))
    ctx.run('sort {0} | uniq > {0}.tmp'.format(listfile))
    os.remove(listfile)
    os.rename('{}.tmp'.format(listfile), listfile)
    with ctx.cd('~/src/dotfiles/'):
        ctx.run('git add brew_list.txt', warn=True)
        ctx.run("git commit -m 'new brews'", warn=True)


def git_update_hooks(ctx, repo):
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


def git_fetch(ctx, repo):
    with ctx.cd(repo):
        if len(ctx.run('git remote').stdout):
            ctx.run('git fetch --all --recurse-submodules=yes --prune')
            ctx.run('git fetch --all --recurse-submodules=yes --prune --tags')
            return True
        else:
            print('\tno remote configured')
            return False


def git_merge_ff(ctx, repo, branch, commit):
    """Merge a branch without checking it out"""
    with ctx.cd(repo):
        branch_ref = 'refs/heads/{0}'.format(branch)
        branch_orig_hash = ctx.run('git show-ref -s --verify {0}'.format(branch_ref)).stdout.strip()
        commit_orig_hash = ctx.run('git rev-parse --verify {0}'.format(commit)).stdout.strip()

        if ctx.run('git symbolic-ref HEAD').stdout.strip() == branch_ref:
            ctx.run('git merge --ff-only "{0}"'.format(commit))

        else:
            if ctx.run("git merge-base {}  {}".format(branch_orig_hash, commit_orig_hash)).stdout != branch_orig_hash:
                print('merging {0} into {1} would not be a fast-forward'.format(commit, branch))

            else:
                print("Updating {}..{}".format(branch, commit))

                ctx.run('git update-ref -m "merge {0}: Fast forward" "{1}" "{2}" "{3}"'.format(commit, branch_ref,
                                                                                               commit_orig_hash,
                                                                                               branch_orig_hash))
                ctx.run('git diff --shortstat "{0}@{{1}}" "{0}"'.format(branch), warn=True)


def git_rebase_branches(ctx, repo):
    with ctx.cd(repo):
        remotes = set(
            b[20:] for b in
            ctx.run("git for-each-ref --format='%(refname)' refs/remotes/origin/").stdout.split('\n')
            if len(b) > 21
        )
        for ref in ctx.run("git for-each-ref --format='%(refname)' refs/heads/").stdout.split('\n'):
            branch = ref[11:]
            if branch in remotes:
                git_merge_ff(ctx, repo, branch, "origin/{}".format(branch))


def git_cleanup(ctx, repo):
    with ctx.cd(repo):
        ctx.run('git gc --auto')


def update_repo(ctx, project, kind):
    if kind == 'git':
        print('updating {}...'.format(project))
        if git_fetch(ctx, project):
            git_rebase_branches(ctx, project)
        git_update_hooks(ctx, project)
        git_cleanup(ctx, project)

    elif kind == 'hg':
        pass

    elif kind == 'svn':
        pass


@task
def update_repos(ctx):
    for repo, kind in yield_repos_in_folder(SRC_DIR):
        update_repo(ctx, repo, kind)


@task
def update_vim(ctx):
    print('update_vim')
    ctx.run('vim "+call dein#update()" +qa')


@task
def new_repo_cache(ctx):
    print('clean local project cache')
    ctx.run('rm -rf ~/.cache/.project_list')


@task
def rustup(ctx):
    print('update rustup')
    ctx.run('rustup update')


@task 
def update_nerdtree_bookmarks():
    bookmark_file = Path('/Users/syphar/.NERDTreeBookmarks')
    if bookmark_file.exists():
        os.remove(bookmark_file)

    with open(bookmark_file, 'w') as f:
        for p in get_all_repos():
            path = Path(p)

            f.write(
                f"{path.parts[-1]} "
                f"{path}\r\n"
            )


@task(default=True)
def update(ctx):
    self_update(ctx)
    update_homebrew(ctx)
    update_zsh(ctx)
    update_repo_cache()
    update_nerdtree_bookmarks()
    rustup(ctx)
    update_repos(ctx)
    update_brew_list(ctx)
    update_vim(ctx)
    new_repo_cache(ctx)
