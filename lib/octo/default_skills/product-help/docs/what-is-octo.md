# What is Octo

Octo is a **functionality-first** AI agent with three equal interfaces:

- **Terminal (CLI)** — Interactive agent sessions in your shell
- **Web UI** — Full chat interface with multi-session support at `localhost:7070`
- **Instant Messaging** — Feishu, WeChat, WeCom, Discord, Telegram

All three interfaces are first-class citizens with identical capabilities.

## Core Protocols

Octo speaks three API protocols natively:

1. **Anthropic Messages** — Claude models with full `cache_control` fidelity
2. **OpenAI** — Chat Completions + Responses API
3. **AWS Bedrock** — Claude via AWS

Any provider exposing one of these shapes works out of the box.

## Key Features

| Feature | Description |
|---|---|
| **Skills** | Installable capability packs in Markdown format |
| **Autonomous Agent** | ReAct pattern with tool execution |
| **BYOK** | Bring your own API key for any compatible model |
| **Session Management** | Persistent conversation history |
| **Memory** | Long-term memory across sessions |

## What Octo Is Not

- Not a token-minimization obsession — functionality comes first
- Not web-first — local CLI usage has no master-worker overhead
- Not a marketplace — skills are open Markdown, not encrypted binaries

Octo is a hard fork of [clacky-ai/openclacky](https://github.com/clacky-ai/openclacky).
