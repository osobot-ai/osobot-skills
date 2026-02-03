#!/bin/bash
# Check oh-my-opencode configuration and model resolution
# Usage: ./doctor.sh [--verbose]

set -e

echo "=== Oh My OpenCode Doctor ==="
echo ""

# Check if opencode is installed
if ! command -v opencode &> /dev/null; then
    echo "ERROR: opencode not found in PATH"
    echo "Install: npm i -g @anthropics/opencode"
    exit 1
fi

echo "OpenCode: $(opencode --version 2>/dev/null || echo 'installed')"

# Check oh-my-opencode
if command -v bunx &> /dev/null; then
    echo "Running oh-my-opencode doctor..."
    echo ""
    bunx oh-my-opencode doctor ${1:+"$1"}
else
    echo "WARNING: bunx not found. Install bun to run oh-my-opencode doctor."
    echo ""
    
    # Manual checks
    echo "Config locations:"
    if [ -f ".opencode/oh-my-opencode.json" ]; then
        echo "  [FOUND] .opencode/oh-my-opencode.json (project)"
    elif [ -f ".opencode/oh-my-opencode.jsonc" ]; then
        echo "  [FOUND] .opencode/oh-my-opencode.jsonc (project)"
    else
        echo "  [NONE]  .opencode/oh-my-opencode.json (project)"
    fi
    
    if [ -f "$HOME/.config/opencode/oh-my-opencode.json" ]; then
        echo "  [FOUND] ~/.config/opencode/oh-my-opencode.json (user)"
    elif [ -f "$HOME/.config/opencode/oh-my-opencode.jsonc" ]; then
        echo "  [FOUND] ~/.config/opencode/oh-my-opencode.jsonc (user)"
    else
        echo "  [NONE]  ~/.config/opencode/oh-my-opencode.json (user)"
    fi
fi
