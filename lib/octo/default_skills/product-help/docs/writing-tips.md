# Skill Writing Tips

## Describe the Trigger Well

The `description` field is how the agent decides when to use your skill. Write it as a condition:

```yaml
description: 'Use this skill when the user wants to set up a new Ruby on Rails project'
```

## Be Specific

Bad:
```
Help with coding.
```

Good:
```
Analyze the current codebase and suggest refactoring opportunities. Focus on performance bottlenecks and code duplication.
```

## Use Examples

Include concrete examples in your instructions:

```
When the user says "make it faster", check:
1. Database queries (look for N+1)
2. Background job opportunities
3. Caching candidates
```

## Set Boundaries with forbidden_tools

If your skill should never modify files or run shell commands:

```yaml
forbidden_tools:
  - write
  - edit
  - terminal
```

## Fork for Complex Tasks

Set `fork_agent: true` when the skill performs multi-step work. This isolates the skill's context from the main session.

## Keep It Maintainable

- One skill = one responsibility
- Update skills based on execution results
- Version your skills by renaming the directory
