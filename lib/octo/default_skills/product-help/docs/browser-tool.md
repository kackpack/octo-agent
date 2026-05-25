# Browser Automation

Octo can control a real browser (Chrome or Edge) for web automation tasks.

## Setup

Use the built-in `browser-setup` skill:

```bash
> /browser-setup
```

Or manually configure `~/.octo/browser.yml`:

```yaml
browser: chrome
remote_debugging_port: 9222
```

## Requirements

- **macOS**: Chrome or Edge installed
- **Linux**: Chrome/Chromium installed
- **Windows/WSL**: Chrome on Windows accessible via remote debugging

## How It Works

Octo connects to the browser via Chrome DevTools Protocol (CDP):

1. Start browser with remote debugging enabled
2. Octo connects to `localhost:9222`
3. Agent can navigate, click, type, scroll, and extract page content

## Supported Actions

- Navigate to URLs
- Click elements
- Type text / fill forms
- Scroll pages
- Take screenshots
- Evaluate JavaScript
- Extract page content

## WSL Setup

For WSL users, the `browser-setup` skill guides you through connecting to Windows Chrome from WSL.

## Troubleshooting

If browser automation fails:
1. Ensure Chrome/Edge is running with `--remote-debugging-port=9222`
2. Check `~/.octo/browser.yml` configuration
3. Run `/browser-setup` to reconfigure
