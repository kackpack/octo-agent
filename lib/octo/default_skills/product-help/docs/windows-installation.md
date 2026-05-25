# Windows Installation

## PowerShell One-liner

```powershell
powershell -c "& ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/Leihb/octo/main/scripts/install.ps1')))"
```

## Manual Installation

1. Install Ruby >= 3.1.0 from [rubyinstaller.org](https://rubyinstaller.org/)
2. Open PowerShell or Command Prompt
3. Run:

```powershell
gem install octo-agent
```

## WSL (Recommended)

For the best experience on Windows, use WSL2:

```bash
# In WSL terminal
/bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/Leihb/octo/main/scripts/install.sh)"
```

Browser automation and most features work best under WSL or native Linux/macOS.

## After Installation

```bash
octo
```

Configure your API key on first run via `> /config`.
