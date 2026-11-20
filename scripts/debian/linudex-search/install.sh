#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[ -f liblinudexsearch.so ] || { echo 'Run ./build.sh first.' >&2; exit 1; }

LIBDIR="$(pkg-config --variable=libdir libxfce4panel-2.0)"
# Preserve old gtk.css, search.svg, and existing launcher: no destructive edit.
# Replace the shared object by atomic rename: the currently loaded module stays
# mapped to the old inode until the panel is restarted.
sudo install -Dm755 liblinudexsearch.so "$LIBDIR/xfce4/panel/plugins/liblinudexsearch.so.new"
sudo mv -f "$LIBDIR/xfce4/panel/plugins/liblinudexsearch.so.new" "$LIBDIR/xfce4/panel/plugins/liblinudexsearch.so"
sudo install -Dm644 linudexsearch.desktop /usr/share/xfce4/panel/plugins/linudexsearch.desktop
install -Dm644 style.css "$HOME/.config/linudex-search/style.css"
install -Dm644 search-icon.svg "$HOME/.local/share/linudex/search-icon.svg"

echo 'Installation completed. Run xfce4-panel -r and test LinuDex Search.'
echo 'The original gtk.css and the previous launcher were not modified.'
