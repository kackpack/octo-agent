# FAQ & Troubleshooting

## General

### Q: What models are supported?

Any model speaking Anthropic Messages, OpenAI (Chat Completions / Responses), or AWS Bedrock protocols. Out-of-the-box presets include:

- **Claude** (Anthropic)
- **GPT** (OpenAI)
- **DeepSeek**
- **Kimi** (Moonshot)
- **MiniMax**
- **OpenRouter**
- **AWS Bedrock**
- **Qwen**
- **GLM**

### Q: Can I use a custom endpoint?

Yes. Set `base_url` to any OpenAI-compatible or Anthropic-compatible endpoint.

### Q: How do I update Octo?

```bash
gem update octo
```

Or pull latest and `bundle install` if running from source.

## Configuration

### Q: Where is the config file stored?

`~/.octo/config.yml`

### Q: Can I have multiple models configured?

Yes. The config supports multiple model entries with different types (default, lite, fallback).

### Q: What if I don't have an API key?

Octo requires your own API key (BYOK). Get one from your model provider (Anthropic, OpenAI, etc.).

## Web UI

### Q: What port does the web UI use?

Default is `8888`. Change with `--port`.

### Q: Can I access the web UI from another device?

Use `--host 0.0.0.0` to listen on all interfaces.

## Restart / Upgrade / Downgrade

### Normal Restart

```bash
kill -USR1 $OCTO_MASTER_PID
```

This performs a hot restart with zero downtime.

### Restart or Upgrade Failure

If restart fails:
1. Check if another process is using the port (`lsof -i :7070` or `:8888`)
2. Kill the stale process and restart
3. If issues persist, run `gem uninstall octo && gem install octo` for a clean reinstall

### Downgrade

```bash
gem install octo -v <desired-version>
```

## Session Management

### Q: Where are sessions stored?

`~/.octo/sessions/`

### Q: How do I continue a previous session?

```bash
octo -c
# or
octo --continue
```

### Q: How do I list recent sessions?

```bash
octo -l
# or
octo --list
```
