#!/bin/bash
# ccmux Codex Stop hook. Codex has no permission-prompt hook in older
# versions, so Stop is the authoritative "turn complete / back to idle"
# signal. Safe no-op when the marker doesn't exist yet.
# Contract: exit 0 on every path, never write to stdout.
MARKERS_DIR="$HOME/.config/ccmux/session-pids"

INPUT=$(cat)
SESSION_ID=$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
[ -n "$SESSION_ID" ] || exit 0

MARKER_FILE="$MARKERS_DIR/codex-$SESSION_ID.json"
[ -f "$MARKER_FILE" ] || exit 0

jq '. + {state: "idle", state_timestamp: now, pending_tool: null, permission_context: null}' \
  "$MARKER_FILE" > "$MARKER_FILE.tmp" 2>/dev/null && mv "$MARKER_FILE.tmp" "$MARKER_FILE" 2>/dev/null

exit 0
