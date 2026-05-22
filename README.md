# dotfiles

Cross-platform zsh configuration with automatic setup for macOS and Linux.

## Quick Start

```bash
git clone <repo-url> ~/Developer/git/dotfiles
cd ~/Developer/git/dotfiles
./setup.sh
```

## What Gets Installed

- **Oh My Zsh** - framework for managing zsh configuration
- **Spaceship Prompt** - minimal, powerful prompt with git integration
- **Autojump** - fast directory navigation (use `j <directory>`)
- **zsh-autosuggestions** - fish-like command suggestions

## Platform Support

The setup script automatically detects your OS and installs dependencies appropriately:

- **macOS**: Uses Homebrew for all packages
- **Linux**: Uses system package manager (apt/dnf/yum/pacman) for autojump, git clone for others

## Configuration Files

- `zshrc_darwin` - macOS-specific configuration
- `zshrc_linux` - Linux-specific configuration
- `setup.sh` - automated installation and symlinking
