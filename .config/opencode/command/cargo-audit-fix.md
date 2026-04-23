---
description: Run cargo audit, minimally update vulnerable crates, and open a PR.
agent: build
---

Fix vulnerabilities reported by `cargo audit` in the current Rust project with the smallest lockfile change that resolves them.

Steps:

1. Preflight:
   - Confirm `Cargo.toml` exists in the current directory. If not, stop.
   - Confirm `cargo-audit` is installed with `cargo audit --version`. If not, stop and tell the user to install it.
   - Confirm the git worktree is clean with `git status --short`. If it is not clean, stop and ask the user to commit or stash changes first.
2. Determine the base branch:
   - Prefer `main` if it exists locally or on `origin`.
   - Otherwise use `master` if it exists locally or on `origin`.
   - If neither exists, stop and ask once.
   - Ensure the local ref is up to date enough to branch from the chosen base.
3. Run `cargo audit --json` and inspect all current advisories.
   - If there are no fixable vulnerabilities, report that and stop.
   - Identify the vulnerable crates that have an available fix.
4. Create a new branch from the chosen base branch named `fix/cargo-audit-YYYY-MM-DD` using today's date.
   - If that branch name already exists locally or remotely, stop and ask the user how to proceed.
5. Apply the smallest dependency update that fixes the reported vulnerabilities:
   - Update only the vulnerable crates identified by `cargo audit`.
   - Use `cargo update -p <crate>` for each affected crate.
   - Do not run a broad `cargo update` unless the user explicitly asks.
   - If an advisory still remains after updating a crate, inspect whether another vulnerable crate also needs a targeted update and continue only with the minimum necessary package updates.
6. Verify the result:
   - Run `cargo audit` again and confirm whether the original advisories are resolved.
   - Run `cargo fmt`, `cargo check`, and `cargo clippy`.
   - If any command fails, fix straightforward issues caused by the dependency updates. If the fix is non-trivial, stop and explain the blocker.
7. Review the exact changes before committing:
   - Inspect `git diff -- Cargo.lock Cargo.toml`.
   - If unrelated dependency changes were introduced, do not continue blindly; explain what happened.
8. Commit only the dependency fix:
   - Stage only the files needed for the update, typically `Cargo.lock` and `Cargo.toml` if it changed.
   - Use a concise commit message such as `fix(deps): resolve cargo audit advisories`.
9. Push and open a PR:
   - Push the new branch to `origin` with upstream tracking.
   - Create a PR against the chosen base branch with `gh pr create --assignee @me`.
   - Use a clear title such as `fix(deps): resolve cargo audit advisories`.
   - In the PR body, summarize the advisories fixed, the crates updated, and mention any remaining advisories if applicable.
10. Report back with:
   - The base branch used.
   - The new branch name.
   - The crates updated.
   - Whether `cargo audit` passed after the change.
   - The PR URL.

Constraints:

- Keep the update minimal and limited to the packages needed to address the audit findings.
- Do not rewrite history or modify unrelated files.
- Do not create a PR if the dependency update was not committed successfully.

$ARGUMENTS
