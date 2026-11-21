---
description: Apply the most recent (or specified) review from .opencode/reviews/ by implementing the findings.
agent: fixer
---

Apply a code review's findings.

Steps:

1. Determine which review file to apply:
   - If `$ARGUMENTS` is a path, use it.
   - Otherwise, list `.opencode/reviews/*.md` and pick the newest by filename (ISO timestamps sort lexicographically).
2. Read the review fully.
3. Implement the changes:
   - Address every `blocker` and `major` finding.
   - Address `minor` and `nit` unless the user asks to skip them.
   - If a finding is wrong or not applicable, note it with a short rationale in the final summary instead of silently skipping.
4. Run the repo's verification (e.g. tests, `pre-commit run --all-files`) and report results.
5. Summarize: which findings were resolved, which were skipped (with reasons), which files changed, what verification was run.

Do not commit or push unless explicitly asked.

$ARGUMENTS
