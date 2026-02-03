# Oh My OpenCode Troubleshooting

## Common Issues

### OpenCode hangs or breaks

**Cause:** Not using PTY mode.

**Fix:** Always use `pty:true`:
```bash
bash pty:true workdir:~/project background:true command:"opencode run 'ulw ...'"
```

### All categories use the same model

**Cause:** Categories not configured in `oh-my-opencode.json`. Without explicit config, all categories fall back to the system default model from `opencode.json`.

**Fix:** Add category configs:
```json
{
  "categories": {
    "quick": { "model": "anthropic/claude-haiku-4-5" },
    "ultrabrain": { "model": "openai/gpt-5.2-codex" }
  }
}
```

**Verify:** Run `npx oh-my-opencode doctor --verbose` to check model resolution.

### Agent stuck in loop

**Cause:** Complex tasks can sometimes cause agents to loop.

**Fix:**
1. Check progress: `process action:log sessionId:XXX`
2. If truly stuck: `process action:kill sessionId:XXX`
3. Restart with more specific instructions

### JSON Parse error with Ollama

**Cause:** Ollama returns NDJSON when streaming, but the SDK expects single JSON.

**Fix:** Disable streaming for Ollama agents:
```json
{
  "agents": {
    "explore": {
      "model": "ollama/qwen3-coder",
      "stream": false
    }
  }
}
```

### Session not resuming

**Fix:** Use the `-c` flag to continue:
```bash
opencode run "ulw Continue the previous task" -c
```

### Background agents not spawning in tmux

**Requirements:**
1. Must be inside a tmux session
2. OpenCode must run with `--port` flag: `opencode --port 4096`
3. `tmux.enabled` must be `true` in config

### Context window exceeded

**Fix options:**
1. Enable experimental truncation:
```json
{
  "experimental": {
    "truncate_all_tool_outputs": true,
    "aggressive_truncation": true
  }
}
```
2. Enable dynamic context pruning:
```json
{
  "experimental": {
    "dynamic_context_pruning": { "enabled": true }
  }
}
```

### Permission denied errors

**Fix:** Configure agent permissions:
```json
{
  "agents": {
    "explore": {
      "permission": {
        "edit": "allow",
        "bash": "allow"
      }
    }
  }
}
```

## Diagnostics

```bash
# Check model resolution and configuration
npx oh-my-opencode doctor --verbose

# Check available models
opencode models

# Check config file location
# Project: .opencode/oh-my-opencode.json
# User: ~/.config/opencode/oh-my-opencode.json
```
