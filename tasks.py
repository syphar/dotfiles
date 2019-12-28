#!/usr/bin/env python
import os
from pathlib import Path

from invoke import task

from projects import SRC_DIR, get_all_repos, yield_repos_in_folder


@task
def self_update(ctx):
    print("self_update")
    ctx.run("git pull")
    ctx.run("pip install --upgrade invoke")


@task
def update_homebrew(ctx):
    print("update_homebrew")

    installed = set(ctx.run("brew list", hide="out").stdout.split())
    with open(
        os.path.join(os.path.expanduser("~"), "src", "dotfiles", "brew_list.txt")
    ) as brew_list:
        for brew in [b.strip() for b in brew_list]:
            if brew not in installed:
                ctx.run("brew install {}".format(brew), warn=True)

    ctx.run("brew update")
    ctx.run("brew upgrade")


@task
def update_pipx(ctx):
    print("update pipx")
    with open(Path(__file__).parent / "pipx_list.txt") as pipx_list:
        for pkg in pipx_list:
            ctx.run(f"pipx install {pkg}")

    ctx.run("pipx upgrade-all")


@task
def cleanup_homebrew(ctx):
    print("cleanup_homebrew")

    ctx.run("brew cleanup")
    ctx.run("brew prune")

    for l in ctx.run("brew missing").stdout.split("\n"):
        if not l:
            continue

        _, pkgs = l.strip().split(":")
        for p in pkgs.split():
            ctx.run("brew install " + p)


@task
def update_zsh(ctx):
    print("update_zsh")
    with ctx.cd("~/.zprezto/"):
        ctx.run("git pull")
        ctx.run("git submodule update --init --recursive")

    with ctx.cd("~/.liquidprompt/"):
        ctx.run("git checkout master")
        ctx.run("git fetch origin")
        ctx.run("git reset origin/master")


@task
def update_brew_list(ctx):
    print("update_brew_list")
    listfile = os.path.expanduser("~/src/dotfiles/brew_list.txt")
    ctx.run("brew list >> {}".format(listfile))
    ctx.run("sort {0} | uniq > {0}.tmp".format(listfile))
    os.remove(listfile)
    os.rename("{}.tmp".format(listfile), listfile)
    with ctx.cd("~/src/dotfiles/"):
        ctx.run("git add brew_list.txt", warn=True)
        ctx.run("git commit -m 'new brews'", warn=True)


def git_update_hooks(ctx, repo):
    hook_dir = Path(repo) / ".git" / "hooks"

    if not hook_dir.exists():
        hook_dir.mkdir()

    local_hooks = Path(__file__).parent / "git-hooks"

    for hook_source in local_hooks.iterdir():
        print(f"setting {hook_source.name}-hook")

        hook_dest = hook_dir / hook_source.name

        if os.path.lexists(hook_dest):
            hook_dest.unlink()

        hook_dest.symlink_to(hook_source)


def git_fetch(ctx, repo):
    with ctx.cd(repo):
        if len(ctx.run("git remote").stdout):
            ctx.run("git fetch --all --recurse-submodules=yes --prune")
            ctx.run("git fetch --all --recurse-submodules=yes --prune --tags")
            return True
        else:
            print("\tno remote configured")
            return False


def git_merge_ff(ctx, repo, branch, commit):
    """Merge a branch without checking it out"""
    with ctx.cd(repo):
        branch_ref = "refs/heads/{0}".format(branch)
        branch_orig_hash = ctx.run(
            "git show-ref -s --verify {0}".format(branch_ref)
        ).stdout.strip()
        commit_orig_hash = ctx.run(
            "git rev-parse --verify {0}".format(commit)
        ).stdout.strip()

        if ctx.run("git symbolic-ref HEAD").stdout.strip() == branch_ref:
            ctx.run('git merge --ff-only "{0}"'.format(commit))

        else:
            if (
                ctx.run(
                    "git merge-base {}  {}".format(branch_orig_hash, commit_orig_hash)
                ).stdout
                != branch_orig_hash
            ):
                print(
                    "merging {0} into {1} would not be a fast-forward".format(
                        commit, branch
                    )
                )

            else:
                print("Updating {}..{}".format(branch, commit))

                ctx.run(
                    'git update-ref -m "merge {0}: Fast forward" "{1}" "{2}" "{3}"'.format(
                        commit, branch_ref, commit_orig_hash, branch_orig_hash
                    )
                )
                ctx.run(
                    'git diff --shortstat "{0}@{{1}}" "{0}"'.format(branch), warn=True
                )


def git_rebase_branches(ctx, repo):
    with ctx.cd(repo):
        remotes = set(
            b[20:]
            for b in ctx.run(
                "git for-each-ref --format='%(refname)' refs/remotes/origin/"
            ).stdout.split("\n")
            if len(b) > 21
        )
        for ref in ctx.run(
            "git for-each-ref --format='%(refname)' refs/heads/"
        ).stdout.split("\n"):
            branch = ref[11:]
            if branch in remotes:
                git_merge_ff(ctx, repo, branch, "origin/{}".format(branch))


def git_cleanup(ctx, repo):
    with ctx.cd(repo):
        ctx.run("git gc --auto")


def update_repo(ctx, project, kind):
    if kind == "git":
        print("updating {}...".format(project))
        if git_fetch(ctx, project):
            git_rebase_branches(ctx, project)
        git_update_hooks(ctx, project)
        git_cleanup(ctx, project)

    elif kind == "hg":
        pass

    elif kind == "svn":
        pass


@task
def update_repos(ctx):
    for repo, kind in yield_repos_in_folder(SRC_DIR):
        update_repo(ctx, repo, kind)


@task
def update_zsh_plugin_repos(ctx):
    for path in Path("~/.zprezto-contrib/").expanduser().iterdir():
        if path.is_dir() and (path / ".git").exists():
            update_repo(ctx, str(path), "git")


@task
def update_vim(ctx):
    print("update_vim")
    ctx.run('nvim "+call dein#update()" +qa')


@task
def rustup(ctx):
    print("update rustup")
    ctx.run("rustup update")


def _update_bookmarks(filename, separator):
    bookmark_file = Path(filename)
    if bookmark_file.exists():
        os.remove(bookmark_file)

    with open(bookmark_file, "w") as f:
        for p in get_all_repos():
            path = Path(p)

            f.write(f"{path.parts[-1]}{separator}" f"{path}\r\n")


@task
def update_vim_bookmarks(ctx):
    _update_bookmarks("/Users/syphar/.NERDTreeBookmarks", " ")
    _update_bookmarks("/Users/syphar/.cache/ctrlp/bkd/cache.txt", "\t")
    # _update_bookmarks("/Users/syphar/.pathmarks", ": ")


@task
def mackup(ctx):
    ctx.run("mackup restore")
    ctx.run("mackup backup")


@task
def mackup_dotfiles(ctx):
    """public configuration files are copied to this dotfiles folder"""
    app_list = (
        "ctags",
        "direnv",
        "git",
        "liquidprompt",
        "neovim",
        "powerlevel10k",
        "prezto",
        "zsh",
    )

    destination_folder = Path(__file__).parent

    from mackup import utils, appsdb

    apps_db = appsdb.ApplicationsDatabase()
    for app_name in app_list:
        print(f"copy application config for {app_name}...")

        files_ = apps_db.get_files(app_name)

        for file_ in files_:
            source = Path("~").expanduser() / file_
            destination = destination_folder / file_

            if not source.exists():
                continue

            if destination.exists():
                utils.delete(str(destination))

            utils.copy(str(source), str(destination))

            with ctx.cd(str(destination_folder)):
                ctx.run(f"git add {file_}")


@task
def autocomplete_cache(ctx):
    ctx.run("heroku autocomplete --refresh-cache")


@task(default=True)
def update(ctx):
    self_update(ctx)
    update_homebrew(ctx)
    update_pipx(ctx)
    update_zsh(ctx)
    update_vim_bookmarks(ctx)
    rustup(ctx)
    update_repos(ctx)
    update_zsh_plugin_repos(ctx)
    update_brew_list(ctx)
    update_vim(ctx)
    mackup(ctx)
    mackup_dotfiles(ctx)
    autocomplete_cache(ctx)
