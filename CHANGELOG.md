# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This project is a hard fork of [clacky-ai/openclacky](https://github.com/clacky-ai/openclacky) at upstream **1.1.6**, renumbered as **0.10.0** in this fork's own SemVer line. Only changes made in this fork (0.11.x and later) are tracked here. For history prior to the fork, see the upstream repository.

## [0.11.1] - 2026-05-25

### Added
- Web UI: show a unified diff for the `edit` tool inline in its tool card
- Agent: take a checkpoint snapshot right after `think()` so the Time Machine has a clean pre-tool-use anchor

### Fixed
- Web UI: a `diff` event emitted during `show_tool_preview` (before the matching `tool_call`) used to overwrite the previous tool card's stdout — typically a `read` card — making `Read(...)` look like it rendered a diff. The diff is now buffered until its owning `tool_call` creates the correct card.
- Web UI: tool card rendering, terminal error display, and todo progress consistency
- Web UI: keep tool groups expanded by default
- Terminal tool: pass `handle_id` into the `run_sync` polling loop so the right task is observed
- Terminal tool: drop the circular `max_duration` default that broke `bundle exec` startup on Ruby 3.3
- Providers: remove fake `octo` / `octoai-sea` provider stubs and update test fixtures accordingly

### Changed
- Renamed the gem from `octo` to `octo-agent` (the `octo` name is already taken on RubyGems by an unrelated project). Repository, author, and email metadata updated to the Leihb fork.
- Attributed the upstream `clacky-ai/openclacky` project in `LICENSE.txt` (stacked copyright) and in both READMEs (fork notice under the language switcher).
- Documentation: README, `.octorules`, and gemspec description aligned around the "three interfaces (CLI / Web / IM), three native protocols (Anthropic Messages / OpenAI / AWS Bedrock)" framing.

### Removed
- Stopped tracking accidentally-committed gem-unpack artifacts (`data.tar.gz`, `metadata.gz`, `checksums.yaml.gz`); added anchored `.gitignore` entries so `gem unpack` at the repo root will not re-pollute the tree.

## [0.11.0] - 2026-05-25

First release published under the new `octo` project name after hard-forking from `clacky-ai/openclacky`. The bulk of this release is rebranding, removing upstream-specific subsystems, and bringing forward openclacky features that hadn't shipped at the fork point.

### Added
- Command history for both CLI and Web UI
- Next-message suggestion (ghost-text) ported from openclacky
- Background task notifications subsystem (migrated `feature/bg-notifications` from openclacky)
- `dedup_key` on background-terminal tasks to prevent the agent from spawning duplicates
- Customizable cancel reason for background tasks
- System-prompt guidance pushing the agent to STOP after starting an async task, and to refine async-task behavior (stop when blocked, continue when independent)
- Forceful anti-polling instruction in the terminal "still-running" status prompt
- Octo logo, channels panel styles, and other first-party visual assets to replace removed brand assets

### Fixed
- Anthropic thinking blocks now correctly extracted as `reasoning_content`
- `reasoning_content` converted to Anthropic thinking blocks when emitted through third-party endpoints, so the round-trip is lossless
- `bin/octo` entry point, banner methods, and lingering `{{BRAND_NAME}}` placeholders after rebrand
- Terminal tool: `__CLACKY_DONE__` marker renamed to `__OCTO_DONE__`
- Web UI: user image upload showing `[object Object]` and Analyzing-indicator ordering
- Web UI: shared CSS that was accidentally removed during the brand/creator cleanup restored
- CLI: logo typo corrected from `OOTO` to `OCTO`
- Server: broadcast the background-task count immediately after a terminal kill so badges stay in sync
- Test suite: resolved pre-existing RSpec failures in terminal and input-area specs

### Removed
- Upstream `openclacky` provider (replaced wholesale with the `octo` provider)
- Brand module and creator hub (this fork is not a commercial / multi-brand product)
- Billing module and the dead frontend code that fed it
- Cost-tracking pipeline (token-usage display in the UI is preserved)

## [0.10.0] - upstream baseline

Hard-fork point. This version corresponds to `clacky-ai/openclacky` at upstream **1.1.6**, renumbered to 0.10.0 to start a clean SemVer line in this fork. No changes from this project are included in 0.10.0; see the upstream repository for prior history.
