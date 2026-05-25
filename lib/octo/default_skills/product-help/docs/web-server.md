# Web UI

Start the Octo web interface:

```bash
octo server
```

Default address: **http://localhost:8888**

## Options

```bash
octo server --port 8080        # Custom port
octo server --host 0.0.0.0     # Listen on all interfaces
octo server --no-compression   # Disable message compression
octo server --no-memory        # Disable automatic memory updates
```

## Features

- Full chat interface with markdown rendering
- Multi-session support
- File attachments (images, documents)
- Session history browser
- Real-time streaming responses

## API Endpoints

The web server exposes a REST API for programmatic access:

- `POST /api/sessions` — Create a new session
- `POST /api/sessions/:id/chat` — Send a message
- `GET /api/sessions/:id` — Get session info
- `DELETE /api/sessions/:id` — End a session

## Security

By default, the server binds to `127.0.0.1` (localhost only). Use `--host 0.0.0.0` with caution — there is no built-in authentication.

## Hot Restart

Send `USR1` to the master process for zero-downtime restart:

```bash
kill -USR1 $OCTO_MASTER_PID
```
