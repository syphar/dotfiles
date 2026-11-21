---
description: Run a strict code review against the base branch. Writes .opencode/reviews/<timestamp>.md and prints it.
agent: reviewer
---

Perform a code review of the current branch against its base branch.

Steps:

1. Determine the base branch (prefer `main`, fall back to `origin/HEAD` target). If unclear, ask once.
2. Gather context:
   - `git status --short`
   - `git log --oneline <base>..HEAD`
   - `git diff --stat <base>...HEAD`
   - `git diff <base>...HEAD` (read fully; use Read on large files rather than truncating).
3. Read any additional files you need for context.
4. Ensure `.opencode/reviews/` exists (create it if not).
5. Write the review to `.opencode/reviews/<UTC-ISO-timestamp>.md` (e.g. `2025-04-16T14-22-01Z.md`). Use the exact format from your agent instructions.
6. Print the review content and end with the artifact path on its own line.

Scope: be strict but prioritized. No code edits. If there are truly no findings, still write the artifact with an empty findings list.

$ARGUMENTS
