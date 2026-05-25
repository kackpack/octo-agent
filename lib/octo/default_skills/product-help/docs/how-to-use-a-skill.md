# How to Use a Skill

A **skill** is a Markdown instruction file that guides the agent to accomplish a specific task using existing tools.

## Installing a Skill

```bash
/skill-add <zip-url-or-local-path>
```

Or place skill files manually:

- **Project-level**: `.octo/skills/<skill-name>/SKILL.md`
- **User-level**: `~/.octo/skills/<skill-name>/SKILL.md`

## Invoking a Skill

In an active session, type `/` followed by the skill name:

```bash
> /code-explorer
```

Use Tab or fuzzy search to find skills quickly.

## Built-in Skills

Octo ships with built-in skills for common tasks:

- `browser-setup` — Configure Chrome/Edge for browser automation
- `channel-manager` — Set up IM platform integrations
- `code-explorer` — Analyze and explore codebases
- `cron-task-creator` — Create scheduled automated tasks
- `product-help` — Help with Octo features and configuration
- And more — type `/` to see the full list

## Skill Format

A skill is a single `SKILL.md` file with YAML frontmatter:

```yaml
---
name: my-skill
description: 'Use this skill when...'
fork_agent: true
user-invocable: true
---

# Skill Instructions

Write detailed instructions here...
```

## Creating a Skill

Describe what you want in natural language, and the agent can draft a `SKILL.md` for you.

Skills are plain Markdown — no compilation, no encryption, no license keys.
