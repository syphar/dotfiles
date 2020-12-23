#!/usr/bin/env python
import os
import shutil
import stat
from urllib.request import urlretrieve
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

    installed = set(ctx.run("brew list --formula -1", hide="out").stdout.split())
    with open(
        os.path.join(os.path.expanduser("~"), "src", "dotfiles", "brew_list.txt")
    ) as brew_list:
        for brew in [b.strip() for b in brew_list]:
            if brew not in installed:
                ctx.run("brew install {}".format(brew), warn=True)

    ctx.run("brew update")
    ctx.run("brew upgrade")
    ctx.run("brew upgrade --cask")


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

    ctx.run("brew cleanup -s")

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


@task
def update_brew_list(ctx):
    print("update_brew_list")
    listfile = os.path.expanduser("~/src/dotfiles/brew_list.txt")
    ctx.run("brew list --formula -1 >> {}".format(listfile))
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
            ctx.run("git fetch --all --prune --tags --force")
            ctx.run("git merge --ff-only", warn=True)
            return True
        else:
            print("\tno remote configured")
            return False


def git_cleanup(ctx, repo):
    with ctx.cd(repo):
        ctx.run("git gc")


def update_repo(ctx, project, kind):
    if kind == "git":
        print("updating {}...".format(project))
        git_fetch(ctx, project)
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


def update_repos_in_folder(ctx, folder):
    for path in Path(folder).expanduser().iterdir():
        if path.is_dir() and (path / ".git").exists():
            update_repo(ctx, str(path), "git")


@task
def update_zsh_plugin_repos(ctx):
    update_repos_in_folder(ctx, "~/.zprezto-contrib/")


@task
def update_tmux_plugins(ctx):
    update_repos_in_folder(ctx, "~/.tmux/plugins/")


@task
def update_vim(ctx):
    print("update_vim")
    ctx.run('nvim "+call dein#update()" +qa')


@task
def rustup(ctx):
    print("update rustup")
    ctx.run("rustup update")
    ctx.run("cargo install-update -a")
    ctx.run("cargo cache --autoclean-expensive")


@task
def update_rust_analyzer(ctx):
    print("update rust-analyzer")

    dest = Path("~/.local/bin/rust-analyzer").expanduser()

    if dest.exists():
        dest.unlink()

    urlretrieve(
        "https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-mac",
        dest,
    )

    dest.chmod(dest.stat().st_mode | stat.S_IEXEC)


@task
def mackup(ctx):
    ctx.run("mackup restore --force")
    ctx.run("mackup backup")


@task
def mackup_dotfiles(ctx):
    """public configuration files are copied to this dotfiles folder"""
    app_list = (
        "alacritty",
        "bat",
        "ctags",
        "ctags_dir",
        "direnv",
        "fd",
        "git",
        "mackup",
        "mybin",
        "myneovim",
        "mytmuxinator",
        "pgsql",
        "powerlevel10k",
        "prezto",
        "ranger",
        "tmate",
        "tmux",
        "tmuxinator",
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
def update_virtualenv(ctx, path, only_package):
    path = Path(path).expanduser()
    pip = path / "bin" / "pip"

    if only_package:
        ctx.run(f"{str(pip)} install -U '{only_package}'", echo=True, pty=True),
    else:
        ctx.run(
            f"{str(pip)} freeze | grep = | cut -d = -f 1 | xargs {str(pip)} install -U",
            echo=True,
            pty=True,
        )


@task
def tldr(ctx):
    ctx.run("tldr --update")


@task
def bat_cache(ctx):
    ctx.run("bat cache --build")


@task
def cleanup_rust_repos(ctx):
    with ctx.cd(SRC_DIR):
        # delete all target directories in rust projects
        ctx.run("fd Cargo.toml --exec rm -rf {//}/target")


@task
def cleanup_direnv(ctx):
    print("cleanup direnv...")
    for repo, kind in yield_repos_in_folder(SRC_DIR):
        direnv = Path(repo) / ".direnv"
        if not direnv.exists():
            continue

        python_environments = sorted(
            [
                p
                for p in direnv.iterdir()
                if p.is_dir() and p.name.startswith("python-")
            ],
            reverse=True,
        )

        for env in python_environments[1:]:
            print(f"\t...deleting {str(env)}")
            shutil.rmtree(str(env))


@task
def cleanup_thermondo(ctx):
    backend_backups = Path(SRC_DIR) / "thermondo" / "backend" / "sql" / "backup"
    if backend_backups.exists():
        shutil.rmtree(str(backend_backups))


@task
def cleanup_docker(ctx):
    ctx.run("docker container prune")
    ctx.run("docker image prune -a")
    ctx.run("docker builder prune -a")
    ctx.run("docker volume prune")
    ctx.run("docker network prune")


@task(default=True)
def update(ctx):
    self_update(ctx)
    update_homebrew(ctx)
    cleanup_homebrew(ctx)
    update_pipx(ctx)
    update_zsh(ctx)
    rustup(ctx)
    update_rust_analyzer(ctx)
    update_repos(ctx)
    cleanup_rust_repos(ctx)
    cleanup_direnv(ctx)
    cleanup_thermondo(ctx)
    update_zsh_plugin_repos(ctx)
    update_tmux_plugins(ctx)
    update_brew_list(ctx)
    update_virtualenv(ctx, "~/src/pyls/venv", "python-language-server")
    update_virtualenv(ctx, "~/src/neovim_env/venv", "")
    mackup(ctx)
    mackup_dotfiles(ctx)
    bat_cache(ctx)
    tldr(ctx)
    update_vim(ctx)
