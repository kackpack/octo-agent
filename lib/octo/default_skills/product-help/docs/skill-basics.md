# Skill Basics

A **skill** is a Markdown file that teaches the agent how to perform a specific task.

## File Structure

```
.skills/my-skill/
  SKILL.md
```

Or at project/user level:

```
.octo/skills/my-skill/SKILL.md
~/.octo/skills/my-skill/SKILL.md
```

## SKILL.md Format

```markdown
---
name: my-skill
description: 'Use this skill when...'
fork_agent: true
user-invocable: true
---

# Instructions

Detailed instructions for the agent...
```

## Frontmatter Fields

| Field | Type | Description |
|---|---|---|
| `name` | string | Skill identifier |
| `description` | string | When to trigger this skill (auto-matching) |
| `fork_agent` | boolean | Run in a subagent (default: false) |
| `user-invocable` | boolean | Allow `/skill-name` invocation (default: true) |
| `auto_summarize` | boolean | Auto-summarize results |
| `forbidden_tools` | array | Tool names the skill cannot use |

## Invocation

- **Auto-trigger**: Agent matches user intent against `description`
- **Manual**: `/skill-name` in chat

## Best Practices

- Write `description` as a natural language trigger condition
- Use `fork_agent: true` for complex tasks to isolate context
- Keep instructions concrete and actionable
- Test skills by invoking them directly
