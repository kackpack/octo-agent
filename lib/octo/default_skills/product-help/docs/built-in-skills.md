# Built-in Skills

Octo ships with the following default skills:

| Skill | Description |
|---|---|
| **browser-setup** | Configure Chrome/Edge for browser automation |
| **channel-manager** | Set up IM platform integrations (Feishu, WeCom, WeChat, Discord, Telegram) |
| **code-explorer** | Explore and analyze project/code structure |
| **cron-task-creator** | Create and manage scheduled automated tasks |
| **onboard** | New user onboarding guide |
| **persist-memory** | Save information to long-term memory |
| **personal-website** | Generate and publish a personal homepage |
| **product-help** | Help with Octo features, configuration, and usage |
| **recall-memory** | Recall information from long-term memory |
| **skill-add** | Install skills from zip URLs or local files |
| **skill-creator** | Create, modify, and optimize skills |

## Location

Built-in skills are stored in:

```
lib/octo/default_skills/
```

## Customization

You can override built-in skills by placing a skill with the same name in:

- `.octo/skills/` (project-level)
- `~/.octo/skills/` (user-level)

User-level skills take precedence over built-in skills.

## Removed Skills

The following skills were previously built-in but removed due to being too opinionated:

- **deploy** — Coupled to Railway + Rails
- **new** — Assumed specific Rails scaffolding

These can still be installed as custom skills via `/skill-add`.
