# Repository Guidelines

## Project Structure & Module Organization

This repository is a personal dotfiles/workstation setup, not a single
application. Dotfiles are managed with [chezmoi](https://chezmoi.io) in
symlink mode; `.chezmoiroot` points it at `home/`, which mirrors `$HOME` using
chezmoi naming (`dot_config/` is `~/.config/`, `executable_` sets +x, `empty_`
keeps empty files, `private_` means mode 600). Shell and tool configs live under
`home/dot_config/` (`fish/`, `nvim/`, `git/`, `hypr/`, `ghostty/`).
Reusable command-line helpers live in `home/bin/`. Top-level files such as the
Justfile and the package lists drive installs and maintenance tasks and are not
deployed.

## Build, Test, and Development Commands

Use `just` as the main entrypoint:

- `just --list`: show available maintenance tasks.
- `just daily-update`: run the full local update workflow.
- `just dotfiles`: `chezmoi re-add` copied files, then `chezmoi apply`.
- `just update-fish`: refresh Fisher plugins and clean Fish state.
- `just update-vim`: run Neovim plugin sync headlessly.

Run targeted checks before finishing changes:

- `fish -n home/dot_config/fish/config.fish`: validate Fish startup config.
- `fish_indent -w home/dot_config/fish/*.fish`: normalize Fish formatting.
- `chezmoi diff`: preview what `chezmoi apply` would change in `$HOME`.

## Coding Style & Naming Conventions

Prefer small, single-purpose scripts. Fish function filenames must match the
function name for autoloading to work. Python uses 4-space indentation and the
repo’s `setup.cfg` conventions: `flake8` line length `88`, `isort` with the
`black` profile, and `mypy` targeting Python 3.10. Keep shell scripts
executable and use descriptive kebab-case or verb-style names such as
`find_worktrees.sh` or `update_cached_heroku_apps`.

## Testing Guidelines

There is no global test suite. Verify the files you touch with the narrowest
relevant command: `fish -n` for Fish, `python -m py_compile` for Python, and
tool-native checks for other configs where available. Prefer non-interactive
checks because some startup files attach to `tmux`.

## Commit & Pull Request Guidelines

Follow Conventional Commits, e.g. `docs(dotfiles): add repository guide` or
`fish: new rust playground`. Keep commits focused and leave the worktree clean.
PRs should summarize the affected tools or configs, note any manual follow-up,
and include screenshots only for visible UI changes such as terminal theme or
editor appearance updates.
