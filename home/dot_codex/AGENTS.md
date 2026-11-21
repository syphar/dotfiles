# Global rules

These rules always apply, regardless of any project-specific `AGENTS.md`.

## Git worktree safety

Before making any code changes, check `git status`.

If the worktree is dirty, stop and ask the user how to proceed. Do not stash,
commit, reset, or discard changes without explicit instruction.

Never use destructive or irreversible git commands without asking the user
first.

- Do not use commands like `git reset`, `git checkout --`, `git clean`, or
  branch deletion unless the user explicitly approves.
- Do not force push unless the user explicitly asks for it.
- Prefer creating a new commit over amending an existing commit.

Aim to leave the repository with a clean `git status` after completing your
changes.

## Commit after completing work

After each logically self-contained change, create a git commit when needed to
leave the repository in a clean state.

- Use Conventional Commits format: `type(scope): subject`
- Common types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`,
  `build`, `ci`, `style`
- Scope is optional but encouraged when the change is localized.
- Keep the subject in the imperative mood and under about 72 characters.
- Add a short body when the reason is not obvious from the subject.
- Prefer multiple small commits over one large commit when a session contains
  distinct units of work.

Do not commit if the user has explicitly asked you not to, or if the change is
clearly a work-in-progress they want to review first.

The goal is a clean working tree before and after the work, not maximizing the
number of commits.

## Pre-commit

If there is a `.pre-commit-config.yaml` file, run pre-commit on the changed
files before presenting the result:

```bash
pre-commit run --files <changed files>
```

## Branch and PR workflow

If you are working in a local git repository and the current branch is `main`
or `master`, create a new branch from that base branch for the current topic
before making code changes.

- Choose a short, descriptive branch name based on the work being done.
- If the correct branch name is unclear, ask once.

If the work should be shared and there is not already a pull request for the
current branch, you may create a draft PR assigned to `@me` after pushing the
branch.

- Use the repository's usual PR title and body style when it is clear from
  existing PRs.
- Do not create a PR if the user explicitly asked you not to, or if the work is
  clearly not ready to review.

## RTK

If the `openrtk` plugin is installed, shell commands are automatically
rewritten through RTK. Run commands normally; do not manually prefix regular
shell commands with `rtk`.

Use `rtk` directly only for RTK meta commands such as:

- `rtk gain`
- `rtk gain --history`
- `rtk discover`
- `rtk proxy <cmd>`

---

# Language conventions

Only use these if there is no project-specific `AGENTS.md`.

## Rust projects

After every code change, run these commands and fix the errors before
presenting the result:

```bash
cargo fmt
cargo check
cargo clippy
```

If tests are needed, use:

```bash
cargo nextest run --no-fail-fast
```

Add imports for things you need. Prefer `use tokio::fs` and `fs::write` over
`tokio::fs::write`.
