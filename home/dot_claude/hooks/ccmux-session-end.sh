#!/bin/bash
# Removes PID marker when Claude session closes
MARKERS_DIR="${CCMUX_HOME:-$HOME/.config/ccmux}/session-pids"
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')

if [ -n "$SESSION_ID" ]; then
  rm -f "$MARKERS_DIR/claude-$SESSION_ID.json"
fi
