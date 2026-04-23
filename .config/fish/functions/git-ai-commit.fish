function git-ai-commit --description 'Generate a commit message for staged changes with Codex'
    argparse a/apply p/print h/help -- $argv
    or return 2

    if set -q _flag_help
        echo "Usage: git-ai-commit [--apply|--print]"
        echo "  (default) generate a commit message, open editor, and commit"
        echo "  --apply   commit directly without opening the editor"
        echo "  --print   print the generated commit message"
        return 0
    end

    if set -q _flag_apply; and set -q _flag_print
        echo "git-ai-commit: --apply and --print cannot be used together" >&2
        return 2
    end

    command git rev-parse --git-dir >/dev/null 2>&1
    or begin
        echo "git-ai-commit: not inside a git repository" >&2
        return 1
    end

    command git diff --cached --quiet --exit-code >/dev/null 2>&1
    set -l diff_status $status
    if test $diff_status -eq 0
        echo "git-ai-commit: nothing staged" >&2
        return 1
    else if test $diff_status -gt 1
        echo "git-ai-commit: failed to inspect staged changes" >&2
        return 1
    end

    set -l diff (command git diff --cached --no-ext-diff | string collect)

    set -l policy_file ~/.config/opencode/commit-message-policy.md
    if not test -f "$policy_file"
        set policy_file /Users/syphar/Dropbox/sync/mackup/.config/opencode/commit-message-policy.md
    end

    if not test -f "$policy_file"
        echo "git-ai-commit: missing policy file at ~/.config/opencode/commit-message-policy.md" >&2
        return 1
    end

    set -l policy (command cat "$policy_file" | string collect)
    if test -z "$policy"
        echo "git-ai-commit: policy file is empty" >&2
        return 1
    end

    set -l prompt "$policy

Staged diff:
$diff"

    set -l output_file (command mktemp)
    or begin
        echo "git-ai-commit: failed to create a temporary output file" >&2
        return 1
    end

    set -l log_file (command mktemp)
    or begin
        command rm -f "$output_file"
        echo "git-ai-commit: failed to create a temporary log file" >&2
        return 1
    end

    printf '%s' "$prompt" | command codex exec \
        --ignore-user-config \
        --ignore-rules \
        --skip-git-repo-check \
        -s read-only \
        --ephemeral \
        -m gpt-5.4-mini \
        --output-last-message "$output_file" \
        - >"$log_file" 2>&1
    or begin
        set -l exit_code $status
        command cat "$log_file" >&2
        command rm -f "$log_file"
        command rm -f "$output_file"
        echo "git-ai-commit: codex failed" >&2
        return $exit_code
    end

    command rm -f "$log_file"

    set -l message (command cat "$output_file" | string collect)
    command rm -f "$output_file"

    if test -z "$message"
        echo "git-ai-commit: codex returned an empty message" >&2
        return 1
    end

    if set -q _flag_print
        printf '%s\n' "$message"
        return 0
    end

    if set -q _flag_apply
        printf '%s\n' "$message" | command git commit -F -
        return $status
    end

    set -l commit_message_file (command mktemp)
    or begin
        echo "git-ai-commit: failed to create a temporary commit message file" >&2
        return 1
    end

    printf '%s\n' "$message" >"$commit_message_file"
    command git commit -e -F "$commit_message_file"
    set -l commit_status $status
    command rm -f "$commit_message_file"
    return $commit_status
end
