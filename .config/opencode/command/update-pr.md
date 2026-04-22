---
description: Refresh the current PR title and body from the branch diff.
model: openai/gpt-5.4
---

Update the existing pull request metadata for the current branch.

Steps:

1. Identify the PR and base branch:
   - Run `gh pr view --json number,title,body,baseRefName,headRefName,url`.
   - Use the PR's `baseRefName` as the base branch.
2. Refresh git refs if needed so the base branch exists locally.
3. Review the branch changes against the PR base branch:
   - `git diff --stat origin/<base>...HEAD`
   - `git diff origin/<base>...HEAD`
4. Rewrite the PR title and body based on the diff.
   - Keep the title concise and specific.
   - Keep the body focused on why the change exists and the main changes included.
   - Preserve useful existing context from the current PR body when it is still accurate.
   - Do not invent details that are not supported by the diff or current PR metadata.
5. Update the PR with `gh pr edit --title ... --body ...`.
6. Print the final title and body you applied, plus the PR URL.

Constraints:

- Assume the PR already exists.
- Do not change code, commits, branches, labels, reviewers, or assignees.
- If `gh pr view` does not resolve a PR for the current branch, stop and ask once.

$ARGUMENTS
