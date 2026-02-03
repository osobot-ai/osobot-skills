---
name: oh-my-opencode
description: Run OpenCode with oh-my-opencode plugin for autonomous coding. Use for building apps, multi-file refactoring, complex features. Supports two modes - ultrawork (ulw keyword for full auto) and Prometheus (Tab + /start-work for planned execution). Triggers on "opencode", "oh-my-opencode", "sisyphus", "ulw", or complex coding tasks.
metadata: {"openclaw":{"emoji":"🪨","homepage":"https://github.com/code-yeongyu/oh-my-opencode"},"requires":{"anyBins":["opencode"]}}
---

# Oh My OpenCode

Use **bash with PTY + background mode** for all OpenCode tasks. The plugin provides autonomous execution until completion.

## Prerequisites

This skill assumes OpenCode and oh-my-opencode are already properly configured with your preferred model providers (API keys and/or OAuth). Configure these before using the skill:

1. **Install OpenCode:** `npm install -g opencode-ai` (or `curl -fsSL https://opencode.ai/install | bash`)
2. **Configure providers:** `opencode auth login` (CLI OAuth) or `/connect` (TUI alternative), or set env vars (`ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, etc.)
3. **Install oh-my-opencode plugin:** Add `"plugin": ["oh-my-opencode@latest"]` to your `opencode.json`
4. **Configure models (optional):** Run `bunx oh-my-opencode install` or edit `~/.config/opencode/oh-my-opencode.json`
5. **Verify:** Run `bunx oh-my-opencode doctor --verbose` to check model resolution

## PTY Required

OpenCode is interactive. Always use `pty:true`:

```bash
# Correct
bash pty:true workdir:~/project background:true command:"opencode run 'ulw Build a REST API'"

# Wrong - may hang or break
bash workdir:~/project background:true command:"opencode run 'ulw Build a REST API'"
```

---

## Two Workflow Modes

### Mode 1: Ultrawork (Quick)

Include `ultrawork` or `ulw` in your prompt. Agent handles everything automatically.

```bash
bash pty:true workdir:~/project background:true command:"opencode run 'ulw Add authentication with JWT and refresh tokens'"
```

**What happens:** Agent explores codebase, researches patterns, implements, verifies, and keeps working until done.

### Mode 2: Prometheus (Planned Execution)

For complex/critical tasks. Creates a detailed plan through interview, then executes systematically.

```bash
# 1. Start Prometheus (press Tab in OpenCode, or include in prompt)
bash pty:true workdir:~/project command:"opencode"
# Then press Tab to enter Prometheus mode

# 2. Describe work - Prometheus interviews you
# 3. Review plan in .sisyphus/plans/*.md
# 4. Run /start-work to execute
```

**When to use Prometheus:**
- Multi-day projects
- Critical production changes
- Complex refactoring spanning many files

---

## Built-in Agents

Invoke specialized agents directly in prompts. Models are configured via `oh-my-opencode.json`, not hardcoded here. See [Configuration Reference](./references/configuration.md) for details.

| Agent | Default Purpose |
|-------|-----------------|
| oracle | Architecture decisions, debugging, code review (read-only) |
| librarian | Documentation lookup, OSS examples, multi-repo analysis |
| explore | Fast codebase grep, pattern finding |
| Metis | Pre-planning analysis, identifies hidden requirements |
| Momus | Plan review and critique |
| Atlas | General purpose sub-agent |
| Hephaestus | Autonomous deep worker via `deep` category (GPT 5.2 Codex) |

Agents are invoked programmatically by Sisyphus via `delegate_task()`. You can also use the `--agent` CLI flag:

```bash
opencode run --agent oracle "Review this authentication design"
opencode run --agent librarian "How does NextAuth implement session refresh?"
```

> **Note:** Within the TUI, Sisyphus automatically delegates to agents. The `@` prefix in natural language (e.g., "ask @oracle") may work as a hint but is not an official invocation mechanism — use `--agent` for CLI or let Sisyphus delegate internally.

---

## Categories (for delegate_task)

When the agent delegates subtasks, it uses categories. Each category has optimal model defaults configured in `oh-my-opencode.json`. See [Configuration Reference](./references/configuration.md#categories) for model setup.

| Category | Use For |
|----------|---------|
| `visual-engineering` | Frontend, UI/UX, styling, animation |
| `ultrabrain` | Deep logical reasoning, complex architecture |
| `deep` | Goal-oriented autonomous problem-solving (Hephaestus agent) |
| `artistry` | Creative/artistic tasks, novel ideas |
| `quick` | Trivial fixes, typos, single file changes |
| `unspecified-low` | General tasks, low effort required |
| `unspecified-high` | General tasks, high effort required |
| `writing` | Documentation, prose, technical writing |

**Important:** Categories only use their optimal defaults if configured in `oh-my-opencode.json`. Without configuration, all categories fall back to the system default model. Run `bunx oh-my-opencode doctor --verbose` to check resolution.

---

## Process Management

```bash
# Start task
bash pty:true workdir:~/project background:true command:"opencode run 'ulw Build feature X'"
# Returns sessionId

# Monitor
process action:log sessionId:XXX
process action:poll sessionId:XXX

# Send input if needed
process action:write sessionId:XXX data:"yes"

# Kill if stuck
process action:kill sessionId:XXX
```

---

## Parallel Execution

### Multiple Independent Tasks

```bash
bash pty:true workdir:~/project-a background:true command:"opencode run 'ulw Build auth module'"
bash pty:true workdir:~/project-b background:true command:"opencode run 'ulw Build payment module'"

process action:list  # Monitor all
```

### Parallel Issue Fixing with Git Worktrees

```bash
# Create isolated branches
git worktree add -b fix/issue-42 /tmp/issue-42 main
git worktree add -b fix/issue-57 /tmp/issue-57 main

# Launch in parallel
bash pty:true workdir:/tmp/issue-42 background:true command:"opencode run 'ulw Fix issue #42: <desc>. Commit when done.'"
bash pty:true workdir:/tmp/issue-57 background:true command:"opencode run 'ulw Fix issue #57: <desc>. Commit when done.'"

# After completion
cd /tmp/issue-42 && git push -u origin fix/issue-42
gh pr create --title "fix: Issue #42" --body "..."

# Cleanup
git worktree remove /tmp/issue-42
```

---

## CLI Reference

```bash
# Basic (always include ulw for autonomous mode)
opencode run "ulw <detailed prompt>"

# Resume last session
opencode run "ulw Continue the previous task" -c

# Attach files for context
opencode run "ulw Refactor based on spec" --file ~/docs/spec.md

# Check model resolution
bunx oh-my-opencode doctor --verbose

# Interactive installer
bunx oh-my-opencode install
```

**Do NOT use:** `--format json` or `--model` flags. The plugin handles model selection.

---

## Best Practices

1. **Always include `ulw`** for autonomous mode
2. **Be specific** with file paths, requirements, constraints
3. **Let Sisyphus finish** - complex builds take time (10-60+ min)
4. **Use workdir** to keep context focused on target project
5. **Verify before reporting** - check `process action:log` output
6. **Configure categories** in `oh-my-opencode.json` to get optimal models per task type

---

## When to Use / Not Use

**USE for:**
- Building new applications from scratch
- Multi-file refactoring
- Complex features spanning multiple files
- Tasks requiring research + implementation

**DO NOT USE for:**
- Simple single-file edits (use built-in edit tools)
- Quick fixes or typos
- Reading/exploring files (use built-in read tool)

---

## Rules

1. **Always use pty:true** - OpenCode needs a terminal
2. **Always use background mode** - tasks can run 10-60+ min
3. **Respect tool choice** - if user asks for OpenCode, use it
4. **Be patient** - don't kill sessions because they're "slow"
5. **NEVER run in bot's own directory** - use target project or temp workspace
6. **Check before confirming** - verify output before telling user it's done

---

## Auto-Notify on Completion

For long tasks, append a wake trigger:

```bash
bash pty:true workdir:~/project background:true command:"opencode run 'ulw Build a todo app.

When completely finished, run: openclaw gateway wake --text \"Done: Built todo app\" --mode now'"
```

---

## Reference Docs

- [Configuration Reference](./references/configuration.md) - Full config options, agents, categories, model resolution
- [Troubleshooting](./references/troubleshooting.md) - Common issues and fixes
