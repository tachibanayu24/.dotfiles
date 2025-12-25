#!/bin/bash
set -euo pipefail

DOTPATH="$HOME"/Workspace/tachibanayu24/.dotfiles

# 既存ファイルの確認関数
confirm_overwrite() {
    local file=$1
    local target="$HOME/$file"

    # シンボリックリンクまたはファイルが存在する場合
    if [ -e "$target" ] || [ -L "$target" ]; then
        # 既に正しいシンボリックリンクの場合はスキップ
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$DOTPATH/$file" ]; then
            echo "✓ $file is already correctly linked"
            return 1
        fi

        echo ""
        echo "File exists: $target"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            return 0
        else
            echo "Skipped: $file"
            return 1
        fi
    fi
    return 0
}

# ドットファイルのシンボリックリンク作成
for f in .??*
do
    [[ "$f" = ".git" ]] && continue
    [[ "$f" = ".gitmodules" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ".claude" ]] && continue
    [[ "$f" == "_old" ]] && continue

    if confirm_overwrite "$f"; then
        ln -snfv "$DOTPATH/$f" "$HOME/$f"
    fi
done

# .config以下のシンボリックリンク作成
echo ""
echo "=== Setting up .config files ==="
mkdir -p "$HOME/.config"
for f in nvim ghostty; do
    target="$HOME/.config/$f"
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$DOTPATH/$f" ]; then
            echo "✓ .config/$f is already correctly linked"
            continue
        fi

        echo ""
        echo "File exists: $target"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ln -snfv "$DOTPATH/$f" "$target"
        else
            echo "Skipped: .config/$f"
        fi
    else
        ln -snfv "$DOTPATH/$f" "$target"
    fi
done

# Karabiner-Elements設定のシンボリックリンク作成
echo ""
echo "=== Setting up Karabiner-Elements ==="
mkdir -p "$HOME/.config/karabiner"
target="$HOME/.config/karabiner/karabiner.json"
if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$DOTPATH/karabiner/karabiner.json" ]; then
        echo "✓ Karabiner config is already correctly linked"
    else
        echo ""
        echo "File exists: $target"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ln -snfv "$DOTPATH/karabiner/karabiner.json" "$target"
        else
            echo "Skipped: Karabiner config"
        fi
    fi
else
    ln -snfv "$DOTPATH/karabiner/karabiner.json" "$target"
fi

# VSCode設定のシンボリックリンク作成
echo ""
echo "=== Setting up VSCode ==="
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$VSCODE_USER_DIR" ]; then
    target="$VSCODE_USER_DIR/settings.json"
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$DOTPATH/vscode/settings.json" ]; then
            echo "✓ VSCode settings is already correctly linked"
        else
            echo ""
            echo "File exists: $target"
            read -p "Overwrite? [y/N] " -n 1 -r
            echo

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                ln -snfv "$DOTPATH/vscode/settings.json" "$target"
            else
                echo "Skipped: VSCode settings"
            fi
        fi
    else
        ln -snfv "$DOTPATH/vscode/settings.json" "$target"
        echo "✓ VSCode settings linked"
    fi

    # 拡張機能のインストール
    if command -v code &> /dev/null; then
        echo ""
        read -p "Install VSCode extensions? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing VSCode extensions..."
            while IFS= read -r extension; do
                # コメント行と空行をスキップ
                [[ "$extension" =~ ^#.*$ ]] && continue
                [[ -z "$extension" ]] && continue
                code --install-extension "$extension" --force
            done < "$DOTPATH/vscode/extensions.txt"
        else
            echo "Skipped: VSCode extensions installation"
        fi
    fi
else
    echo "VSCode is not installed. Skipping VSCode setup."
fi

echo ""
echo "✅ Dotfiles installation completed!"
echo ""
echo "📝 Next steps:"
echo "  1. Run: brew bundle --file=$DOTPATH/Brewfile"
echo "  2. Reload shell: source ~/.zshrc"
