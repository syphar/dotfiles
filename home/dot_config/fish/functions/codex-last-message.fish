function codex-last-message --description 'Run codex with stdin and print the last message'
    argparse m/model= h/help -- $argv
    or return 2

    if set -q _flag_help
        echo "Usage: codex-last-message [--model MODEL]"
        echo "  Reads the prompt from stdin and prints the model's last message"
        return 0
    end

    set -l model gpt-5.4-mini
    if set -q _flag_model
        set model "$_flag_model"
    end

    set -l output_file (command mktemp)
    or begin
        echo "codex-last-message: failed to create a temporary output file" >&2
        return 1
    end

    set -l log_file (command mktemp)
    or begin
        command rm -f "$output_file"
        echo "codex-last-message: failed to create a temporary log file" >&2
        return 1
    end

    command codex exec \
        --ignore-user-config \
        --ignore-rules \
        --skip-git-repo-check \
        -s read-only \
        --ephemeral \
        -m "$model" \
        --output-last-message "$output_file" \
        - >"$log_file" 2>&1
    or begin
        set -l exit_code $status
        command cat "$log_file" >&2
        command rm -f "$log_file"
        command rm -f "$output_file"
        echo "codex-last-message: codex failed" >&2
        return $exit_code
    end

    command rm -f "$log_file"

    set -l message (command cat "$output_file" | string collect)
    command rm -f "$output_file"

    if test -z "$message"
        echo "codex-last-message: codex returned an empty message" >&2
        return 1
    end

    printf '%s\n' "$message"
end
