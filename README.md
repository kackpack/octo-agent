# Octo

[![Build](https://img.shields.io/github/actions/workflow/status/octo-ai/octo/main.yml?label=build&style=flat-square)](https://github.com/octo-ai/octo/actions)
[![Release](https://img.shields.io/gem/v/octo?label=release&style=flat-square&color=blue)](https://rubygems.org/gems/octo)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.1.0-red?style=flat-square)](https://www.ruby-lang.org)
[![Downloads](https://img.shields.io/gem/dt/octo?label=downloads&style=flat-square&color=brightgreen)](https://rubygems.org/gems/octo)
[![License](https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square)](LICENSE.txt)

<p align="center">
  <a href="README.md">English</a> · <a href="README_CN.md">简体中文</a>
</p>

> Contributing? Read **[CONTRIBUTING.md](./CONTRIBUTING.md)** before opening a PR.

**The most Token-efficient open-source AI Agent.**

Octo matches Claude Code on capability at comparable cost, and saves significantly against other open-source agents (~50% vs OpenClaw, ~3× cheaper than Hermes). 100% open source (MIT), BYOK with any OpenAI-compatible model, built on two years of Agentic R&D and harness engineering.

> Website: https://www.octo.com/ · Backed by **MiraclePlus · ZhenFund · Sequoia China · Hillhouse Capital**

## Why Octo?

Same task, how much do you pay? Under comparable agent workloads, Octo saves a large amount of Token spend compared to mainstream alternatives.

| Agent | Relative cost | Notes |
|---|---|---|
| **Octo** | **~0.8** | 16 tools · ~100% cache hit · subagent routing |
| Claude Code | 1.0× (baseline) | World-class harness, closed-source subscription |
| OpenClaw | ~1.5× | Comparable harness agent |
| Hermes | ~3× | 52 built-in tools — schema bloat ~3–4× |

*Numbers are averages measured on internal common agent tasks, using Claude Code as the baseline. Full benchmark reports will be published on GitHub.*

## Feature comparison

Core agent capability is roughly on par across the field — the real differentiators are **cost, openness, Skill evolution, and integrations**.

| Feature | Claude Code | OpenClaw | Hermes | **Octo** |
|---|:---:|:---:|:---:|:---:|
| Token cost | 1.0× | ~1.5× | ~3× | **~0.8** |
| Open source | ❌ Closed | ✅ Open | ✅ Open | ✅ MIT |
| BYOK / model freedom | ❌ Anthropic only | ✅ | ✅ | ✅ |
| Skill self-evolution | ❌ | ❌ | ✅ | ✅ |
| IM integration (Feishu/WeCom/WeChat/Discord/Telegram) | ❌ | ✅ | ✅ | ✅ |

## How we get the cost down

Not by cutting features — by compounding the right choice at every layer.

### 1. Ultra-high cache hit rate
Sessions never restart, double cache markers, **Insert-then-Compress** — the system prompt is never mutated, so compression still reuses the cache. **Measured cache hit rate: near 100%.**

### 2. Minimal tool set
Only **16 core tools**. Capabilities are offloaded to the Skill ecosystem via a single `invoke_skill` meta-tool. Tool count is not the metric — task completion rate is.

| Octo | Claude Code | OpenClaw | Hermes |
|:--:|:--:|:--:|:--:|
| **16** | 40+ | 23 | 52 |

### 3. Idle-time auto-compression
Go to a meeting, grab coffee — the agent compresses long context in the background and pre-warms the cache. Your first message back hits the cache directly. **Cold-start first-token cost reduced by 50%+.**

### 4. BYOK — you pick the model, you set the cost
Any OpenAI-compatible API, plug and play. Official direct, aggregate routing, compatible relays — the choice is 100% yours. Use Claude for code, auto-route subtasks to DeepSeek, save another chunk of tokens.

Built on **2 years · 3 generations of agentic architecture · 6 core harness engineering decisions**.

## Skills — the soul of the agent

- **Invoke with `/`** — instant browse, fuzzy search, direct call. Hundreds of Skills at your fingertips.
- **Create Skills in natural language** — just describe what you want; the agent drafts `SKILL.md`, breaks down steps, and runs validation. No code required.
- **Self-evolving** — after each run, the agent updates the Skill based on execution context and results. The next call is more stable and more accurate.
- **Open & compatible** — supports Claude Skills / Markdown Pack / custom formats.
- **Monetizable** — polished Skills can be packaged for sale, with encrypted distribution, License management, and creator-defined pricing.

## Installation

### Desktop installer (recommended)

Double-click to install — environment, dependencies, and Skills all set up automatically.

- **macOS** — [Download `.dmg`](https://oss.1024code.com/octo-installer/official/octo-installer.dmg) (Apple Silicon / Intel)
- **Windows** — [Download `.exe`](https://oss.1024code.com/octo-installer/official/octo-installer.exe) (Windows 10 2004+ / Windows 11)

More options: https://www.octo.com/

### Command line

One-line install(Mac/Ubuntu):

```bash
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/octo-ai/octo/main/scripts/install.sh)"
```

Windows:

```bash
powershell -c "& ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/octo-ai/octo/main/scripts/install.ps1')))"
```

or using Ruby(3.x/4.x):

**Requirements:** Ruby >= 3.1.0

```bash
gem install octo
```

see more: https://www.octo.com/docs/installation


## Quick Start

### Terminal (CLI)

```bash
octo            # start interactive agent in current directory
```

### Web UI

```bash
octo server     # default: http://localhost:7070
```

Open **http://localhost:7070** for a full chat interface with multi-session support — run coding, copywriting, research sessions in parallel.

Options:

```bash
octo server --port 8080        # custom port
octo server --host 0.0.0.0     # listen on all interfaces (remote access)
```

## Configuration

```bash
$ octo
> /config
```

Set your **API Key**, **Model**, and **Base URL** (any OpenAI-compatible provider).

Supported out of the box: **Claude (Anthropic) · GPT (OpenAI) · DeepSeek · Kimi (Moonshot) · MiniMax · OpenRouter** — or any custom endpoint.

## Coding use case

Octo works as a general AI coding assistant — scaffold full-stack apps, add features, or explore unfamiliar codebases:

```bash
$ octo
> /new my-app        # scaffold a new project
> Add user auth with email and password
> How does the payment module work?
```

## Star History

<a href="https://www.star-history.com/?repos=octo-ai%2Focto&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=octo-ai/octo&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=octo-ai/octo&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=octo-ai/octo&type=date&legend=top-left" />
 </picture>
</a>

## Advanced — Creator Program

Already power users are turning their workflows into vertical AI experts on Octo — encrypted distribution, License management, self-set pricing. Legal, healthcare, financial planning, and more.

Learn more: https://www.octo.com/ → Creators

## Install from Source

```bash
git clone https://github.com/octo-ai/octo.git
cd octo
bundle install
bin/octo
```

## Trust & Credibility

- **100% open source** — MIT License, all code public, all decisions traceable
- **2 years of Agentic R&D** — 3 generations of architecture
- **16 core tools** — minimal by design
- **Backed by** MiraclePlus · ZhenFund · Sequoia China · Hillhouse Capital

## Contributors

Every line of code, bug report, and thoughtful review matters. Thank you for making Octo better.

<a href="https://github.com/octo-ai/octo/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=octo-ai/octo" />
</a>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/octo-ai/octo. Contributors are expected to adhere to the [code of conduct](https://github.com/octo-ai/octo/blob/main/CODE_OF_CONDUCT.md).

## License

Available as open source under the [MIT License](https://opensource.org/licenses/MIT).
