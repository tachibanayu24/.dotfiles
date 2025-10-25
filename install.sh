#!/bin/bash

DOTPATH="$HOME"/Workspace/tachibanayu24/.dotfiles

for f in .??*
do
    [[ "$f" = ".git" ]] && continue
    [[ "$f" = ".gitmodules" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == "_old" ]] && continue

    ln -snfv "$DOTPATH/$f" "$HOME"/"$f"
    echo "$f"
done
