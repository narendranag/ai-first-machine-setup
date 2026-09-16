#!/usr/bin/env bash
# UserPromptSubmit hook: remember when this turn started, so the Stop hook can tell a long run.
input="$(cat)"
sid="$(printf '%s' "$input" | jq -r '.session_id // "default"' 2>/dev/null)"
date +%s > "${TMPDIR:-/tmp}/claude-turn-$sid"
exit 0
