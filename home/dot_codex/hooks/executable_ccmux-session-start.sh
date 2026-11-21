#!/bin/bash
# ccmux Codex SessionStart hook. Writes PID marker so the daemon can bind
# this pane to the real Codex session id and transcript path.
# Contract: exit 0 on every path, never write to stdout.
MARKERS_DIR="$HOME/.config/ccmux/session-pids"
mkdir -p "$MARKERS_DIR" 2>/dev/null || exit 0

INPUT=$(cat)
# One jq spawn extracts every payload field we care about, shell-quoted via
# @sh so eval is injection-safe even on hostile values.
eval "$(printf '%s' "$INPUT" | jq -r '
  @sh "SESSION_ID=\(.session_id // "")",
  @sh "TRANSCRIPT_PATH=\(.transcript_path // "")"
' 2>/dev/null)"
[ -n "$SESSION_ID" ] || exit 0

CODEX_TTY=$(ps -p $PPID -o tty= 2>/dev/null | tr -d ' ')

MARKER_FILE="$MARKERS_DIR/codex-$SESSION_ID.json"
jq -nc \
  --arg pid "$PPID" \
  --arg tty "${CODEX_TTY:-unknown}" \
  --arg session_id "$SESSION_ID" \
  --arg transcript_path "$TRANSCRIPT_PATH" \
  '{agent_type: "codex", pid: ($pid|tonumber), tty: $tty, session_id: $session_id, transcript_path: (if $transcript_path == "" then null else $transcript_path end), state: "idle", state_timestamp: now, timestamp: now}' \
  > "$MARKER_FILE.tmp" 2>/dev/null && mv "$MARKER_FILE.tmp" "$MARKER_FILE" 2>/dev/null

exit 0
