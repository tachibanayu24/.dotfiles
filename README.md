# .dotfiles

Personal dotfiles configuration for tachibanayu24

## 📦 What's Included

- **Zsh** - Shell configuration with ZIM Framework
- **Neovim** - Modern setup based on kickstart.nvim
- **VSCode** - Editor settings and extensions
- **Git** - Config with useful aliases
- **Brewfile** - Package management for Homebrew

## 🚀 Setup

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Required Tools

```bash
# Clone repository
git clone git@github.com:tachibanayu24/dotfiles.git ~/Workspace/tachibanayu24/.dotfiles
cd ~/Workspace/tachibanayu24/.dotfiles

# Install packages from Brewfile
brew bundle --file=./Brewfile
```

### 3. Install Dotfiles

```bash
sh install.sh
```

### 4. Neovim Initial Setup

Plugins will be automatically installed on first launch:

```bash
nvim
# Plugin installation will start automatically
# After completion, run `:checkhealth` to verify the environment
```
