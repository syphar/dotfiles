function generate-commit-message --description 'Generate a commit message for staged changes with Codex'
    command git rev-parse --git-dir >/dev/null 2>&1
    or begin
        echo "generate-commit-message: not inside a git repository" >&2
        return 1
    end

    command git diff --cached --quiet --exit-code >/dev/null 2>&1
    set -l diff_status $status
    if test $diff_status -eq 0
        echo "generate-commit-message: nothing staged" >&2
        return 1
    else if test $diff_status -gt 1
        echo "generate-commit-message: failed to inspect staged changes" >&2
        return 1
    end

    set -l diff (command git diff --cached --no-ext-diff | string collect)

    set -l policy_file ~/.config/opencode/commit-message-policy.md
    set -l policy (command cat "$policy_file" | string collect)

    set -l prompt "$policy

Staged diff:
$diff"

    set -l message (printf '%s' "$prompt" | codex-last-message | string collect)
    or return $status

    printf '%s\n' "$message"
end
