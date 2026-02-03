# Oh My OpenCode Configuration Reference

## Config File Locations

Priority order:
1. `.opencode/oh-my-opencode.json` (project-level)
2. `~/.config/opencode/oh-my-opencode.json` (user-level)

Supports JSONC (comments + trailing commas). Use `.jsonc` extension for explicit JSONC.

## Quick Start

Most users don't need manual config. Run the interactive installer:

```bash
bunx oh-my-opencode install   # recommended
npx oh-my-opencode install    # alternative
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

| Agent | Default Model | Default Role | Provider Priority Chain |
|-------|--------------|-------------|------------------------|
| **Sisyphus** | `claude-opus-4-5` | Primary orchestrator | anthropic, kimi-for-coding, zai-coding-plan, openai, google |
| **oracle** | `gpt-5.2` | Architecture, debugging, code review | openai, google, anthropic |
| **librarian** | `glm-4.7` | Documentation lookup, OSS examples | zai-coding-plan, opencode, anthropic |
| **explore** | `claude-haiku-4-5` | Codebase grep, pattern finding | anthropic, github-copilot, opencode |
| **multimodal-looker** | `gemini-3-flash` | Visual/image analysis | google, openai, zai-coding-plan, kimi-for-coding, anthropic, opencode |
| **Prometheus (Planner)** | `claude-opus-4-5` | Work planning methodology | anthropic, kimi-for-coding, openai, google |
| **Metis (Plan Consultant)** | `claude-opus-4-5` | Pre-planning analysis | anthropic, kimi-for-coding, openai, google |
| **Momus (Plan Reviewer)** | `gpt-5.2` | Plan critique | openai, anthropic, google |
| **Atlas** | `claude-sonnet-4-5` | General purpose sub-agent | anthropic, kimi-for-coding, openai, google |

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
| `description` | string | Human-readable description |
| `mode` | string | Agent mode |
| `color` | string | Agent color in UI |
| `category` | string | Inherit settings from a category |
| `textVerbosity` | string | Text verbosity level (`low`, `medium`, `high`) |
| `providerOptions` | object | Provider-specific options passed to SDK |
| `stream` | boolean | Enable/disable streaming (set `false` for Ollama) |

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
| `deep` | gpt-5.2-codex | openai, anthropic, google |
| `artistry` | gemini-3-pro (max) | google, anthropic, openai |
| `quick` | claude-haiku-4-5 | anthropic, google, opencode |
| `unspecified-low` | claude-sonnet-4-5 | anthropic, openai, google |
| `unspecified-high` | claude-opus-4-5 (max) | anthropic, openai, google |
| `writing` | gemini-3-flash | google, anthropic, zai-coding-plan, openai |

### Category Options

Each category supports:

| Option | Type | Description |
|--------|------|-------------|
| `model` | string | Override model |
| `temperature` | number | Sampling temperature |
| `top_p` | number | Nucleus sampling |
| `maxTokens` | number | Max response tokens |
| `thinking` | object | Extended thinking config (Anthropic) |
| `reasoningEffort` | string | OpenAI reasoning level |
| `textVerbosity` | string | Text verbosity (`low`, `medium`, `high`) |
| `tools` | array | Override available tools |
| `prompt_append` | string | Append to system prompt |
| `variant` | string | Model variant (`max`, `high`, `medium`, `low`, `xhigh`) |
| `description` | string | Human-readable description |
| `is_unstable_agent` | boolean | Mark as unstable (experimental) |

### Custom Categories

You can define your own categories beyond the built-in 8:

```json
{
  "categories": {
    "my-custom-category": {
      "model": "openai/gpt-5.2",
      "description": "Custom category for specific use case",
      "temperature": 0.5
    }
  }
}
```

### Recommended Config

```json
{
  "categories": {
    "visual-engineering": { "model": "google/gemini-3-pro-preview" },
    "ultrabrain": { "model": "openai/gpt-5.2-codex", "variant": "xhigh" },
    "deep": { "model": "openai/gpt-5.2-codex" },
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

Check resolution with: `bunx oh-my-opencode doctor --verbose`

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

- **playwright** (default): Browser automation via `@playwright/mcp`
- **agent-browser**: Vercel's CLI with session management, parallel browsers
- **git-master**: Git operations (atomic commits, rebase, history search)

Available skill names (for `disabled_skills`): `playwright`, `agent-browser`, `git-master`

Disable: `{ "disabled_skills": ["playwright"] }`

### Browser Automation Engine

Switch between browser automation providers:

```json
{
  "browser_automation_engine": {
    "provider": "agent-browser"
  }
}
```

| Provider | Description |
|----------|-------------|
| `playwright` (default) | MCP tools via `@playwright/mcp` |
| `agent-browser` | Vercel's CLI with session management, parallel browsers. Requires `bun add -g agent-browser` |

## Built-in MCPs

Exa (web search), Context7 (library docs), grep.app (code search) enabled by default.

Disable: `{ "disabled_mcps": ["websearch", "context7", "grep_app"] }`

## Disabled Agents

Disable specific agents from being used:

```json
{
  "disabled_agents": ["oracle", "multimodal-looker"]
}
```

Available agents: `sisyphus`, `prometheus`, `oracle`, `librarian`, `explore`, `multimodal-looker`, `metis`, `momus`, `atlas`

## Disabled Commands

Disable specific slash commands:

```json
{
  "disabled_commands": ["init-deep"]
}
```

## Skills Configuration

Define custom skills or configure skill sources:

```json
{
  "skills": {
    "sources": [
      { "path": "./custom-skills", "recursive": true },
      "https://example.com/skill.yaml"
    ],
    "enable": ["my-custom-skill"],
    "disable": ["other-skill"],
    "my-skill": {
      "description": "Custom skill description",
      "template": "Skill prompt template",
      "model": "anthropic/claude-sonnet-4-5",
      "agent": "sisyphus",
      "allowed-tools": ["tool1", "tool2"]
    }
  }
}
```

| Option | Type | Description |
|--------|------|-------------|
| `sources` | array | Local paths or remote URLs for skill definitions |
| `enable` | array | Explicitly enable specific skills |
| `disable` | array | Disable specific skills |
| `[skill-name]` | object | Per-skill configuration (description, template, model, agent, allowed-tools) |

## Tmux Integration

Visual multi-agent execution in tmux panes:

```json
{
  "tmux": {
    "enabled": true,
    "layout": "main-vertical",
    "main_pane_size": 60,
    "main_pane_min_width": 80,
    "agent_pane_min_width": 40
  }
}
```

**Requirements:**
- Must be running inside a tmux session
- OpenCode must run with `--port` flag: `opencode --port 4096`

### Layout Options

| Layout | Description |
|--------|-------------|
| `main-vertical` | Main pane on left, agent panes stacked on right |
| `main-horizontal` | Main pane on top, agent panes stacked below |
| `tiled` | Equal-sized panes in a grid |
| `even-horizontal` | All panes side-by-side horizontally |
| `even-vertical` | All panes stacked vertically |

### How It Works

Subagent panes are spawned automatically when Sisyphus delegates tasks. Each subagent connects to the main OpenCode instance via `opencode attach`. You can define shell helper functions for convenience (e.g., `omo()` to start OpenCode in tmux with the right port).

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
- `anthropic-context-window-limit-recovery`

## Google Auth (Antigravity Plugin)

For Google Gemini authentication, the recommended companion plugin is `opencode-antigravity-auth`:

```json
{
  "plugin": [
    "oh-my-opencode",
    "opencode-antigravity-auth@latest"
  ]
}
```

Features:
- Multi-account load balancing
- Variant-based thinking levels
- Dual quota system (Antigravity + Gemini CLI)

## Environment Variables

| Variable | Description |
|----------|-------------|
| `OPENCODE_PORT` | Default port for HTTP server (used for tmux integration) |

Provider-specific environment variables (set during installation or in your shell):
- `ANTHROPIC_API_KEY` — Anthropic API key
- `OPENAI_API_KEY` — OpenAI API key
- `GOOGLE_API_KEY` — Google Gemini API key
