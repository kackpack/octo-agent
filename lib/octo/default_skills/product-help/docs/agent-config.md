# Model & API Key Configuration

## Interactive Configuration

During a session:

```bash
> /config
```

This opens an interactive prompt to set:

- **API Key** — Your model provider key
- **Model** — Model identifier (e.g., `anthropic/claude-opus-4-7`)
- **Base URL** — Provider endpoint
- **Anthropic Format** — Whether to use native Anthropic Messages format

## Config File

Configuration is stored in `~/.octo/config.yml`:

```yaml
models:
  - model: anthropic/claude-opus-4-7
    api_key: sk-xxx
    base_url: https://api.anthropic.com
    type: default
    anthropic_format: true
  - model: anthropic/claude-haiku-4-5
    api_key: sk-xxx
    base_url: https://api.anthropic.com
    type: lite
```

## Environment Variables

| Variable | Description |
|---|---|
| `OCTO_API_KEY` | Default model API key |
| `OCTO_BASE_URL` | Default model base URL |
| `OCTO_MODEL` | Default model name |
| `OCTO_ANTHROPIC_FORMAT` | Use anthropic format |
| `OCTO_LITE_API_KEY` | Lite model API key |
| `OCTO_LITE_BASE_URL` | Lite model base URL |
| `OCTO_LITE_MODEL` | Lite model name |

ClaudeCode-compatible variables are also supported:

| Variable | Description |
|---|---|
| `ANTHROPIC_API_KEY` | API key |
| `ANTHROPIC_BASE_URL` | Base URL |

## Model Types

- **default** — Primary model for main agent work
- **lite** — Cheaper/faster model for subagents and simple tasks
- **fallback** — Used when the primary model is unavailable

## Supported Providers

Octo has built-in presets for:

- **openrouter** — `https://openrouter.ai/api/v1`
- **anthropic** — `https://api.anthropic.com`
- **openai** — `https://api.openai.com`
- **bedrock** — AWS Bedrock
- **deepseek** — `https://api.deepseek.com`
- **kimi** — `https://api.moonshot.cn`
- **minimax** — `https://api.minimax.chat`
- **qwen** — `https://dashscope.aliyuncs.com`
- **glm** — `https://open.bigmodel.cn/api/paas/v4`

Use any custom endpoint by specifying `base_url` directly.
