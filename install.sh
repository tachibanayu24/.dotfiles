#!/bin/bash

DOTPATH="$HOME"/Workspace/tachibanayu24/.dotfiles

# ドットファイルのシンボリックリンク作成
for f in .??*
do
    [[ "$f" = ".git" ]] && continue
    [[ "$f" = ".gitmodules" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == "_old" ]] && continue

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

# .config以下のシンボリックリンク作成
mkdir -p "$HOME/.config"
for f in nvim; do
    ln -snfv "$DOTPATH/$f" "$HOME/.config/$f"
done

# VSCode設定のシンボリックリンク作成
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$VSCODE_USER_DIR" ]; then
    ln -snfv "$DOTPATH/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
    echo "VSCode settings linked"

    # 拡張機能のインストール
    if command -v code &> /dev/null; then
        echo "Installing VSCode extensions..."
        while IFS= read -r extension; do
            # コメント行と空行をスキップ
            [[ "$extension" =~ ^#.*$ ]] && continue
            [[ -z "$extension" ]] && continue
            code --install-extension "$extension" --force
        done < "$DOTPATH/vscode/extensions.txt"
    fi
fi

echo ""
echo "✅ Dotfiles installation completed!"
echo ""
echo "📝 Next steps:"
echo "  1. Run: brew bundle --file=$DOTPATH/Brewfile"
echo "  2. Reload shell: source ~/.zshrc"
