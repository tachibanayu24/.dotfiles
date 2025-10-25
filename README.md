# .dotfiles

Personal dotfiles configuration for tachibanayu24

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

This will automatically create symbolic links:
- `.zshrc` → `~/.zshrc`
- `.zimrc` → `~/.zimrc`
- `.gitconfig` → `~/.gitconfig`
- `nvim/` → `~/.config/nvim/`

### 4. Neovim Initial Setup

Plugins will be automatically installed on first launch:

```bash
nvim
# Plugin installation will start automatically
# After completion, run `:checkhealth` to verify the environment
```
