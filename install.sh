#!/bin/bash

DOTPATH="$HOME"/Workspace/tachibanayu24/.dotfiles

for f in .??*
do
    [[ "$f" = ".git" ]] && continue
    [[ "$f" = ".gitmodules" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -snfv "$DOTPATH/$f" "$HOME"/"$f"
    echo "$f"
done
