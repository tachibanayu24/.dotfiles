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

echo ""
echo "✅ Dotfiles installation completed!"
echo ""
echo "📝 Next steps:"
echo "  1. Run: brew bundle --file=$DOTPATH/Brewfile"
echo "  2. Reload shell: source ~/.zshrc"
