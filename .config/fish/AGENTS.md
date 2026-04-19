# AGENTS.md

## Scope

- This repo is a Fish shell config, not an application repo. There is no
  build/test/lint pipeline here; verification is file-level Fish syntax checks.

## Verify Changes

- Run `fish -n <file>` and `fish_indent -w <file>` on every edited `.fish` file
  before finishing.
- For edits to startup wiring, also run `fish -n config.fish`.
- Prefer non-interactive verification only. `config.fish` auto-attaches or
  starts `tmux` for interactive shells when `$TMUX` is unset.

## Structure

- `config.fish` is the startup entrypoint. It sources `aliases.fish`,
  `key_bindings.fish`, `environment.fish`, and `colors.fish` in that order
  before `starship init fish | source`.
- `functions/*.fish` are Fish autoloaded functions. Keep the filename identical
  to the function name, or Fish autoload will stop working.
- `conf.d/*.fish` is for plugin/runtime auto-load snippets; current plugin set
  is declared in `fish_plugins` and managed by Fisher.

## Repo-Specific Behavior

- Interactive startup enables `fzf_configure_bindings --directory=\cf`,
  `direnv hook fish`, and `zoxide init fish --cmd cd | source`; `cd` behavior is
  intentionally overridden by zoxide.
- Interactive startup also raises `ulimit -n 10000`; do not move that into
  non-interactive paths unless you intend to affect every Fish invocation.
- Key bindings assume vi mode via `fish_vi_key_bindings`; preserve that when
  editing `key_bindings.fish`.

## Custom Worktree Helpers

- `create-workspace` and `remove-workspace` are custom git worktree helpers in
  `functions/`.
- `create-workspace` must work from either the main repo or a linked worktree,
  creates sibling worktrees next to the main repo, and copies root `.env*` files
  into the new worktree.
- `remove-workspace` is intended to run from inside a linked worktree, `cd`s
  back to the main repo before removal, and supports `--force` only for dirty
  worktree removal; it does not delete the branch.
