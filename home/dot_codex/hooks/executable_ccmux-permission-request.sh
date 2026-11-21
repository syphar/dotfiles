#!/bin/bash
# ccmux Codex PermissionRequest hook. Flags the session as waiting for
# user approval so the sidebar shows an attention indicator.
# Contract: exit 0 on every path, never write to stdout/stderr. An
# exit 2 with stderr is interpreted by Codex as Deny.
MARKERS_DIR="/home/syphar/.config/ccmux/session-pids"

INPUT=$(cat)
# One jq spawn extracts every payload field, shell-quoted via @sh so eval
# is injection-safe. Keeps us well under Codex's 1s hook budget on the
# user-approval path.
eval "$(printf '%s' "$INPUT" | jq -r '
  @sh "SESSION_ID=\(.session_id // "")",
  @sh "TOOL_NAME=\(.tool_name // "")",
  @sh "COMMAND=\(.tool_input.command // "")"
' 2>/dev/null)"
[ -n "$SESSION_ID" ] || exit 0

MARKER_FILE="$MARKERS_DIR/codex-$SESSION_ID.json"
[ -f "$MARKER_FILE" ] || exit 0

jq --arg tool "$TOOL_NAME" --arg ctx "$COMMAND" \
  '. + {state: "waiting_permission", state_timestamp: now, pending_tool: (if $tool == "" then null else $tool end), permission_context: (if $ctx == "" then null else $ctx end)}' \
  "$MARKER_FILE" > "$MARKER_FILE.tmp" 2>/dev/null && mv "$MARKER_FILE.tmp" "$MARKER_FILE" 2>/dev/null

exit 0
