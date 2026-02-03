# Oh My OpenCode Configuration Reference

## Config File Locations

Priority order:
1. `.opencode/oh-my-opencode.json` (project-level)
2. `~/.config/opencode/oh-my-opencode.json` (user-level)

Supports JSONC (comments + trailing commas). Use `.jsonc` extension for explicit JSONC.

## Quick Start

Most users don't need manual config. Run the interactive installer:

```bash
npx oh-my-opencode install
```

## Schema

```json
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json"
}
```

## Agents

Override built-in agent models and behavior:

```json
{
  "agents": {
    "oracle": {
      "model": "openai/gpt-5.2",
      "temperature": 0.3
    },
    "explore": {
      "model": "anthropic/claude-haiku-4-5"
    },
    "multimodal-looker": {
      "disable": true
    }
  }
}
```

### Available Agents

| Agent | Default Role | Provider Priority Chain |
|-------|-------------|------------------------|
| **Sisyphus** | Primary orchestrator | anthropic, kimi-for-coding, zai-coding-plan, openai, google |
| **oracle** | Architecture, debugging, code review | openai, google, anthropic |
| **librarian** | Documentation lookup, OSS examples | zai-coding-plan, opencode, anthropic |
| **explore** | Codebase grep, pattern finding | anthropic, github-copilot, opencode |
| **multimodal-looker** | Visual/image analysis | google, openai, zai-coding-plan, anthropic |
| **Prometheus (Planner)** | Work planning methodology | anthropic, kimi-for-coding, openai, google |
| **Metis (Plan Consultant)** | Pre-planning analysis | anthropic, kimi-for-coding, openai, google |
| **Momus (Plan Reviewer)** | Plan critique | openai, anthropic, google |
| **Atlas** | General purpose sub-agent | anthropic, kimi-for-coding, openai, google |

### Agent Options

| Option | Type | Description |
|--------|------|-------------|
| `model` | string | Override model (e.g., `anthropic/claude-opus-4-5`) |
| `temperature` | number | Sampling temperature |
| `top_p` | number | Nucleus sampling |
| `maxTokens` | number | Max response tokens |
| `prompt` | string | Replace system prompt |
| `prompt_append` | string | Append to system prompt |
| `tools` | array | Override available tools |
| `disable` | boolean | Disable this agent |
| `variant` | string | Model variant (`max`, `high`, `medium`, `low`, `xhigh`) |
| `thinking` | object | Extended thinking config (Anthropic) |
| `reasoningEffort` | string | OpenAI reasoning (`low`, `medium`, `high`, `xhigh`) |
| `permission` | object | Fine-grained permissions |

### Thinking Options (Anthropic)

```json
{
  "agents": {
    "oracle": {
      "thinking": {
        "type": "enabled",
        "budgetTokens": 200000
      }
    }
  }
}
```

### Permission Options

```json
{
  "agents": {
    "explore": {
      "permission": {
        "edit": "deny",
        "bash": "ask",
        "webfetch": "allow"
      }
    }
  }
}
```

Permissions: `edit`, `bash`, `webfetch`, `doom_loop`, `external_directory`. Values: `ask`, `allow`, `deny`.

## Categories

Categories enable domain-specific task delegation via `delegate_task`. Each has optimal model defaults, but **must be configured to use them**.

### Built-in Categories

| Category | Default Model | Provider Priority |
|----------|--------------|-------------------|
| `visual-engineering` | gemini-3-pro | google, anthropic, zai-coding-plan |
| `ultrabrain` | gpt-5.2-codex (xhigh) | openai, google, anthropic |
| `artistry` | gemini-3-pro (max) | google, anthropic, openai |
| `quick` | claude-haiku-4-5 | anthropic, google, opencode |
| `unspecified-low` | claude-sonnet-4-5 | anthropic, openai, google |
| `unspecified-high` | claude-opus-4-5 (max) | anthropic, openai, google |
| `writing` | gemini-3-flash | google, anthropic, zai-coding-plan, openai |

### Recommended Config

```json
{
  "categories": {
    "visual-engineering": { "model": "google/gemini-3-pro-preview" },
    "ultrabrain": { "model": "openai/gpt-5.2-codex", "variant": "xhigh" },
    "quick": { "model": "anthropic/claude-haiku-4-5" },
    "unspecified-low": { "model": "anthropic/claude-sonnet-4-5" },
    "unspecified-high": { "model": "anthropic/claude-opus-4-5", "variant": "max" },
    "writing": { "model": "google/gemini-3-flash-preview" }
  }
}
```

Only configure categories for providers you have access to. Unconfigured categories use the system default model.

## Model Resolution

3-step priority:
1. **User override** in oh-my-opencode.json (highest)
2. **Provider fallback chain** for the agent/category
3. **System default** from opencode.json (lowest)

Check resolution with: `npx oh-my-opencode doctor --verbose`

## Sisyphus Agent

```json
{
  "sisyphus_agent": {
    "disabled": false,
    "default_builder_enabled": false,
    "planner_enabled": true,
    "replace_plan": true
  }
}
```

| Option | Default | Description |
|--------|---------|-------------|
| `disabled` | false | Disable all Sisyphus orchestration |
| `default_builder_enabled` | false | Enable OpenCode-Builder alongside Sisyphus |
| `planner_enabled` | true | Enable Prometheus (Planner) |
| `replace_plan` | true | Demote default plan agent to subagent |

## Background Tasks

```json
{
  "background_task": {
    "defaultConcurrency": 5,
    "staleTimeoutMs": 180000,
    "providerConcurrency": {
      "anthropic": 3,
      "openai": 5,
      "google": 10
    },
    "modelConcurrency": {
      "anthropic/claude-opus-4-5": 2
    }
  }
}
```

Priority: modelConcurrency > providerConcurrency > defaultConcurrency

## Built-in Skills

- **playwright** (default) / **agent-browser**: Browser automation
- **git-master**: Git operations (atomic commits, rebase, history search)

Disable: `{ "disabled_skills": ["playwright"] }`

## Built-in MCPs

Exa (web search), Context7 (library docs), grep.app (code search) enabled by default.

Disable: `{ "disabled_mcps": ["websearch", "context7", "grep_app"] }`

## Tmux Integration

Visual multi-agent execution in tmux panes:

```json
{
  "tmux": {
    "enabled": true,
    "layout": "main-vertical",
    "main_pane_size": 60
  }
}
```

Requires running inside tmux with `opencode --port 4096`.

## Git Master

```json
{
  "git_master": {
    "commit_footer": true,
    "include_co_authored_by": true
  }
}
```

## Experimental Features

```json
{
  "experimental": {
    "truncate_all_tool_outputs": false,
    "aggressive_truncation": false,
    "auto_resume": false,
    "dynamic_context_pruning": {
      "enabled": false,
      "turn_protection": { "enabled": true, "turns": 3 }
    }
  }
}
```

## Available Hooks

Disable via `disabled_hooks`:
- `todo-continuation-enforcer`, `context-window-monitor`, `session-recovery`
- `session-notification`, `comment-checker`, `grep-output-truncator`
- `tool-output-truncator`, `directory-agents-injector`, `directory-readme-injector`
- `empty-task-response-detector`, `think-mode`, `rules-injector`
- `background-notification`, `auto-update-checker`, `startup-toast`
- `keyword-detector`, `agent-usage-reminder`, `non-interactive-env`
- `interactive-bash-session`, `compaction-context-injector`
- `thinking-block-validator`, `claude-code-hooks`, `ralph-loop`
- `preemptive-compaction`, `auto-slash-command`, `sisyphus-junior-notepad`, `start-work`
