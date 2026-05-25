# Memory System

Octo maintains **long-term memory** across sessions.

## Storage Location

```
~/.octo/memories/
```

Memories are stored as Markdown files with YAML frontmatter.

## How It Works

- The agent automatically reads relevant memories at the start of a session
- New information can be persisted to memory during a session
- Memories are topic-organized and searchable

## Manual Memory Management

Use the `persist-memory` skill to save information:

```bash
> /persist-memory
```

Use the `recall-memory` skill to retrieve information:

```bash
> /recall-memory
```

## Disabling Memory

When starting the web server:

```bash
octo server --no-memory
```

## Memory Files

Each memory file contains:

```yaml
---
topics:
  - topic-name
created_at: 2026-01-01
type: factual
---

Content here...
```

## Scope

- **User-level**: `~/.octo/memories/` — Shared across all projects
- **Project-level**: `.octo/memories/` — Project-specific

The agent loads both scopes and merges them by relevance.
