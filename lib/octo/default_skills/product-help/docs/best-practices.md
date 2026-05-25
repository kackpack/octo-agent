# Advanced Patterns & Best Practices

## Skill Composition

Break complex workflows into smaller skills that call each other:

- `setup-project` — Initialize repository structure
- `add-auth` — Add authentication
- `add-tests` — Add test suite

## Context Management

- Use `fork_agent: true` for tasks that need clean context
- Use `auto_summarize: true` for long-running tasks
- Use `forbidden_tools` to restrict what a skill can do

## Testing Skills

Before distributing a skill:

1. Run it yourself in multiple scenarios
2. Check edge cases (empty input, invalid paths)
3. Verify it handles errors gracefully

## Versioning

Version skills by directory name:

```
skills/
  my-skill-v1/
  my-skill-v2/
```

## Project-Specific Defaults

Place a `.octorules` file in project root to give the agent context about your codebase conventions.

## Performance

- Lite models (`anthropic/claude-haiku-4-5`, etc.) are great for simple tasks
- Use fallback models for reliability
- Disable memory with `--no-memory` if you don't need persistence

## Security

- Never commit API keys to version control
- Use `forbidden_tools` to restrict file/shell access for untrusted skills
- Run with `--mode=confirm_all` when working with sensitive codebases
