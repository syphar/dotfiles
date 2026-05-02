# Repository Guidelines

## Project Structure & Module Organization

This repository is a personal dotfiles/workstation setup, not a single
application. Top-level files such as [Brewfile](/Users/syphar/src/dotfiles/Brewfile)
and [Justfile](/Users/syphar/src/dotfiles/Justfile) drive package installs and
maintenance tasks. Shell and tool configs live under `.config/` (`fish/`,
`nvim/`, `kitty/`, `git/`, `ranger/`, `opencode/`). Reusable command-line
helpers live in `bin/`, with topic-specific scripts in subfolders such as
`bin/docsrs/` and `bin/thermondo/`. Mackup mapping files live in `.mackup/`.

## Build, Test, and Development Commands

Use `just` as the main entrypoint:

- `just --list`: show available maintenance tasks.
- `just daily-update`: run the full local update workflow.
- `just mackup`: sync managed config files into this repo.
- `just update-fish`: refresh Fisher plugins and clean Fish state.
- `just update-vim`: run Neovim plugin sync headlessly.

Run targeted checks before finishing changes:

- `fish -n .config/fish/config.fish`: validate Fish startup config.
- `fish_indent -w .config/fish/*.fish`: normalize Fish formatting.
- `python -m py_compile mackup_dotfiles.py`: quick sanity check for Python
  scripts.

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
