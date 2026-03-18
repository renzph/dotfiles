#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.cargo/bin:$PATH"

INPUT=$(cat)
NAME=$(echo "$INPUT" | jq -r .name)
CWD=$(echo "$INPUT" | jq -r .cwd)
DIR="$HOME/.claude/worktrees/$NAME"

jj workspace add "$DIR" >&2
echo "$DIR"
