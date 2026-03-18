#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.cargo/bin:$PATH"

INPUT=$(cat)
DIR=$(echo "$INPUT" | jq -r .worktree_path)

if [ -d "$DIR/.jj" ]; then
  (cd "$DIR" && jj workspace forget) >&2 || true
  rm -rf "$DIR"
fi
