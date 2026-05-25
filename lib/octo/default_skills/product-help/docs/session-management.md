# Session Management

## Starting a Session

```bash
octo
```

## Continuing a Session

```bash
octo -c
octo --continue
```

## Listing Sessions

```bash
octo -l
octo --list
```

## Attaching to a Specific Session

```bash
octo -a 2          # By number
octo -a b6682a87   # By session ID prefix
```

## Storage

Sessions are stored in:

```
~/.octo/sessions/
```

Each session is a Markdown file with conversation history and metadata.

## Session Files

Sessions are chunked and organized by date:

```
~/.octo/sessions/
  2026-05-25/
    session-id-1.md
    session-id-2.md
```

## Web UI Sessions

The web UI supports multiple concurrent sessions. Each browser tab can have its own independent session.

## Session Limits

- Context window depends on the model being used
- Older messages may be compressed to fit within token limits
- Use `--no-compression` to disable compression (saves tokens but may lose context)

## Cleanup

Sessions are kept indefinitely. To clean up old sessions, manually remove files from `~/.octo/sessions/`.
