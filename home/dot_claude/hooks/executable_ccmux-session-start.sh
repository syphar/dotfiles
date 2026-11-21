#!/bin/bash
# Writes PID marker when Claude session starts/resumes
MARKERS_DIR="${CCMUX_HOME:-$HOME/.config/ccmux}/session-pids"
mkdir -p "$MARKERS_DIR"

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')

if [ -n "$SESSION_ID" ]; then
  CLAUDE_PID=""
CLAUDE_TTY=""
WALK="$PPID"
for _ in 1 2 3 4 5 6 7 8; do
  [ -n "$WALK" ] || break
  [ "$WALK" = "1" ] && break
  [ "$WALK" = "0" ] && break
  W_COMM=$(ps -o comm= -p "$WALK" 2>/dev/null | tr -d ' ')
  W_TTY=$(ps -o tty= -p "$WALK" 2>/dev/null | tr -d ' ')
  case "$W_COMM" in
    claude|*/claude)
      CLAUDE_PID="$WALK"; CLAUDE_TTY="$W_TTY"; break ;;
  esac
  # No controlling terminal prints "??" on macOS/BSD ps and "?" on Linux.
  case "$W_TTY" in
    ""|"?"|"??"|"-") ;;
    *) [ -z "$CLAUDE_PID" ] && { CLAUDE_PID="$WALK"; CLAUDE_TTY="$W_TTY"; } ;;
  esac
  WALK=$(ps -o ppid= -p "$WALK" 2>/dev/null | tr -d ' ')
done
[ -n "$CLAUDE_PID" ] || CLAUDE_PID="$PPID"
[ -n "$CLAUDE_TTY" ] || CLAUDE_TTY=$(ps -p "$PPID" -o tty= 2>/dev/null | tr -d ' ')
# Normalize every no-tty spelling to the marker's sentinel.
case "$CLAUDE_TTY" in
  ""|"?"|"??"|"-") CLAUDE_TTY="unknown" ;;
esac

  # Clean up any existing marker for this PID (handles session switch in same terminal)
  for f in "$MARKERS_DIR"/*.json; do
    [ -f "$f" ] || continue
    if grep -q "\"pid\": *$CLAUDE_PID[^0-9]" "$f" 2>/dev/null; then
      rm -f "$f"
    fi
  done

  MARKER_FILE="$MARKERS_DIR/claude-$SESSION_ID.json"
  jq -nc \
    --arg pid "$CLAUDE_PID" \
    --arg tty "$CLAUDE_TTY" \
    --arg session_id "$SESSION_ID" \
    '{agent_type: "claude", pid: ($pid|tonumber), tty: $tty, session_id: $session_id, state: "idle", state_timestamp: now, timestamp: now}' \
    > "$MARKER_FILE.tmp" && mv "$MARKER_FILE.tmp" "$MARKER_FILE"
fi
