# SKILL.md Frontmatter Reference

All frontmatter fields for `SKILL.md`:

## Required Fields

| Field | Type | Description |
|---|---|---|
| `name` | string | Skill identifier (kebab-case recommended) |
| `description` | string | Natural language trigger condition |

## Optional Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `fork_agent` | boolean | false | Run in a subagent with isolated context |
| `user-invocable` | boolean | true | Allow `/skill-name` manual invocation |
| `auto_summarize` | boolean | false | Automatically summarize results |
| `forbidden_tools` | array | [] | Tool names the skill cannot use |

## Example

```yaml
---
name: code-explorer
description: 'Use this skill when exploring, analyzing, or understanding project/code structure'
fork_agent: true
user-invocable: true
auto_summarize: true
forbidden_tools:
  - write
  - edit
  - terminal
---
```

## Trigger Matching

The `description` field is matched against user intent using semantic similarity. Write it as a condition:

```yaml
description: 'Use this skill when the user asks about browser setup, Chrome configuration, or Edge automation'
```

## fork_agent Behavior

When `fork_agent: true`:
- A new subagent is spawned
- The subagent gets a fresh context
- Results are summarized back to the parent session
- Prevents long skill executions from polluting main session context

## forbidden_tools

Common values:

- `write` — Cannot create files
- `edit` — Cannot modify files
- `terminal` — Cannot run shell commands
- `web_search` — Cannot search the web
- `browser` — Cannot control browser
