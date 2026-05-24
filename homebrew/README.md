# Homebrew Formula for Octo

This directory contains the Homebrew formula for Octo.

## For Maintainers: Publishing to Homebrew Tap

### One-time Setup

1. Create a GitHub repository named `homebrew-octo` (must start with `homebrew-`)
2. Push this formula to the repository

```bash
# In your GitHub account, create: homebrew-octo
git clone https://github.com/YOUR_USERNAME/homebrew-octo.git
cd homebrew-octo
cp /path/to/octo/homebrew/octo.rb ./Formula/octo.rb
git add Formula/octo.rb
git commit -m "Add octo formula"
git push origin main
```

### Update Formula for New Release

When you release a new version:

1. Download the new gem and calculate SHA256:
```bash
VERSION=0.6.1
wget https://rubygems.org/downloads/octo-${VERSION}.gem
shasum -a 256 octo-${VERSION}.gem
```

2. Update the formula in `homebrew-octo` repository:
- Update `url` with new version
- Update `sha256` with calculated hash
- Commit and push

3. Users can then upgrade:
```bash
brew update
brew upgrade octo
```

## For Users: Installation

```bash
# Add the tap (one-time)
brew tap YOUR_USERNAME/octo

# Install
brew install octo

# Or in one command
brew install YOUR_USERNAME/octo/octo
```

## Testing the Formula Locally

```bash
# Install from local formula
brew install --build-from-source ./homebrew/octo.rb

# Or test without installing
brew test ./homebrew/octo.rb
```

## Automation Script

For easier updates, use this script:

```bash
#!/bin/bash
# update_formula.sh

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Usage: ./update_formula.sh VERSION"
  exit 1
fi

# Download gem
wget https://rubygems.org/downloads/octo-${VERSION}.gem -O /tmp/octo.gem

# Calculate SHA256
SHA256=$(shasum -a 256 /tmp/octo.gem | cut -d' ' -f1)

# Update formula
sed -i '' "s|url \".*\"|url \"https://rubygems.org/downloads/octo-${VERSION}.gem\"|" octo.rb
sed -i '' "s|sha256 \".*\"|sha256 \"${SHA256}\"|" octo.rb

echo "Formula updated to version ${VERSION}"
echo "SHA256: ${SHA256}"
echo "Don't forget to commit and push to homebrew-octo repository!"

rm /tmp/octo.gem
```
