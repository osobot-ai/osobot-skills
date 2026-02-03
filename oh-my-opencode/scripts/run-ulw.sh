#!/bin/bash
# Quick launcher for ultrawork mode
# Usage: ./run-ulw.sh <workdir> "<prompt>"
# Example: ./run-ulw.sh ~/my-project "Build a REST API with authentication"

set -e

WORKDIR="${1:-.}"
PROMPT="${2:-}"

if [ -z "$PROMPT" ]; then
    echo "Usage: $0 <workdir> \"<prompt>\""
    echo "Example: $0 ~/my-project \"Build a REST API with auth\""
    exit 1
fi

if [ ! -d "$WORKDIR" ]; then
    echo "ERROR: Directory not found: $WORKDIR"
    exit 1
fi

echo "=== Launching Ultrawork ==="
echo "Workdir: $WORKDIR"
echo "Prompt: $PROMPT"
echo ""

cd "$WORKDIR"
exec opencode run "ulw $PROMPT"
