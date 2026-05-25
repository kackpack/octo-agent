# Project Rules (.octorules)

The `.octorules` file contains project-specific instructions for the agent.

## Location

Place `.octorules` in your project root:

```
my-project/
  .octorules
  src/
  ...
```

## Format

A Markdown file with sections:

```markdown
# Project Rules

## Overview

This is a Ruby on Rails API project...

## Architecture

- Models in app/models/
- Controllers in app/controllers/
- Services in app/services/

## Code Style

- Use frozen_string_literal: true
- Single quotes for strings without interpolation
- Max line length: 100

## Testing

- RSpec for tests
- Run `bundle exec rspec` before committing
```

## What to Include

- Project overview and tech stack
- Architecture conventions
- Code style guidelines
- Testing requirements
- Security considerations
- Deployment notes

## How It Works

When you run `octo` in a directory containing `.octorules`, the agent reads this file and incorporates the instructions into its context. This ensures consistent behavior across sessions for the same project.

## User-Level Rules

You can also place `.octorules` in `~/.octo/` for global defaults that apply to all projects.

Project-level rules override user-level rules when there are conflicts.
