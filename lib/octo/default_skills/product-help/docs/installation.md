# Installation

## Requirements

- Ruby >= 3.1.0

## RubyGem

```bash
gem install octo-agent
```

## One-line Installer (macOS / Ubuntu)

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/Leihb/octo/main/scripts/install.sh)"
```

## Windows

```powershell
powershell -c "& ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/Leihb/octo/main/scripts/install.ps1')))"
```

## From Source

```bash
git clone https://github.com/Leihb/octo.git
cd octo
bundle install
bin/octo
```

## After Installation

Run `octo` to start an interactive agent session. On first run, configure your API key and model:

```bash
$ octo
> /config
```

Set your **API Key**, **Model**, and **Base URL**. Octo routes each model to its native protocol automatically.

## Environment Variables

You can also configure via environment variables:

| Variable | Description |
|---|---|
| `OCTO_API_KEY` | Default model API key |
| `OCTO_BASE_URL` | Default model base URL |
| `OCTO_MODEL` | Default model name |
| `OCTO_ANTHROPIC_FORMAT` | Use anthropic format (true/false) |
| `OCTO_LITE_API_KEY` | Lite model API key |
| `OCTO_LITE_BASE_URL` | Lite model base URL |
| `OCTO_LITE_MODEL` | Lite model name |

Or use ClaudeCode-compatible variables: `ANTHROPIC_API_KEY`, `ANTHROPIC_BASE_URL`.
