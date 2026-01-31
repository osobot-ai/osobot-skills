---
name: oh-my-opencode
description: Run OpenCode with oh-my-opencode plugin for autonomous coding. Use for building apps, multi-file refactoring, complex features. Supports two modes - ultrawork (ulw keyword for full auto) and Prometheus (Tab + /start-work for planned execution). Triggers on "opencode", "oh-my-opencode", "sisyphus", "ulw", or complex coding tasks.
metadata: {"openclaw":{"emoji":"🪨","homepage":"https://github.com/code-yeongyu/oh-my-opencode"},"requires":{"anyBins":["opencode"]}}
---

# Oh My OpenCode

Use **bash with PTY + background mode** for all OpenCode tasks. The plugin provides autonomous execution until completion.

## ⚠️ PTY Required

OpenCode is interactive — always use `pty:true`:

```bash
# ✅ Correct
bash pty:true workdir:~/project background:true command:"opencode run 'ulw Build a REST API'"

# ❌ Wrong - may hang or break
bash workdir:~/project background:true command:"opencode run 'ulw Build a REST API'"
```

---

## Two Workflow Modes

### Mode 1: Ultrawork (Quick — Just Do It)

Include `ultrawork` or `ulw` in your prompt. Agent handles everything automatically.

```bash
bash pty:true workdir:~/project background:true command:"opencode run 'ulw Add authentication with JWT and refresh tokens'"
```

**What happens:** Agent explores codebase → researches patterns → implements → verifies → keeps working until done.

### Mode 2: Prometheus (Precise — Planned Execution)

For complex/critical tasks. Creates a detailed plan through interview, then executes systematically.

```bash
# 1. Start Prometheus (press Tab in OpenCode, or include in prompt)
bash pty:true workdir:~/project command:"opencode"
# Then press Tab to enter Prometheus mode

# 2. Describe work → Prometheus interviews you
# 3. Review plan in .sisyphus/plans/*.md
# 4. Run /start-work to execute
```

**When to use Prometheus:**
- Multi-day projects
- Critical production changes
- Complex refactoring spanning many files

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

## Built-in Agents

Invoke specialized agents directly in prompts:

| Agent | Model | Use For |
|-------|-------|---------|
| `@oracle` | GPT-5.2 | Architecture decisions, debugging, code review (read-only) |
| `@librarian` | GLM-4.7 | Documentation lookup, OSS examples, multi-repo analysis |
| `@explore` | Haiku 4.5 | Fast codebase grep, pattern finding |

```bash
opencode run "Ask @oracle to review this authentication design"
opencode run "Ask @librarian how NextAuth implements session refresh"
```

---

## Categories (for delegate_task)

When the agent delegates subtasks, it uses categories:

| Category | Model | Use For |
|----------|-------|---------|
| `visual-engineering` | Gemini 3 Pro | Frontend, UI/UX, styling |
| `ultrabrain` | GPT-5.2 | Deep reasoning, architecture |
| `quick` | Haiku 4.5 | Trivial fixes, typos |
| `unspecified-low` | Sonnet 4.5 | General tasks, low effort |
| `unspecified-high` | Opus 4.5 | General tasks, high effort |

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
```

**Do NOT use:** `--format json` or `--model` flags — plugin handles these.

---

## Best Practices

1. **Always include `ulw`** for autonomous mode
2. **Be specific** — include file paths, requirements, constraints
3. **Let Sisyphus finish** — complex builds take time (10-60+ min)
4. **Use workdir** — keeps context focused on target project
5. **Verify before reporting** — check `process action:log` output

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

1. **Always use pty:true** — OpenCode needs a terminal
2. **Always use background mode** — tasks can run 10-60+ min
3. **Respect tool choice** — if user asks for OpenCode, use it
4. **Be patient** — don't kill sessions because they're "slow"
5. **NEVER run in bot's own directory** — use target project or temp workspace
6. **Check before confirming** — verify output before telling user it's done

---

## Auto-Notify on Completion

For long tasks, append a wake trigger:

```bash
bash pty:true workdir:~/project background:true command:"opencode run 'ulw Build a todo app.

When completely finished, run: openclaw gateway wake --text \"Done: Built todo app\" --mode now'"
```
