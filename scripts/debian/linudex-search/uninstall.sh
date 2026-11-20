#!/usr/bin/env bash
set -euo pipefail
LIBDIR="$(pkg-config --variable=libdir libxfce4panel-2.0)"
echo 'Remove LinuDex Search from the XFCE panel before continuing.'
read -r -p 'Remove LinuDex Search? [y/N] ' answer
case "$answer" in y|Y|yes|YES) ;; *) exit 0;; esac
sudo rm -f "$LIBDIR/xfce4/panel/plugins/liblinudexsearch.so" \
    /usr/share/xfce4/panel/plugins/linudexsearch.desktop
rm -f "$HOME/.config/linudex-search/style.css" \
    "$HOME/.local/share/linudex/search-icon.svg"
echo 'Removed. Restart the panel with xfce4-panel -r.'
