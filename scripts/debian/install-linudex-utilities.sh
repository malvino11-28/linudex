#!/usr/bin/env bash
# Install the Linudex v0.5.1 utility shortcuts in Debian. Do not replace XFCE panel XML.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
BIN="$HOME/.local/bin"
ASSETS="$HOME/.local/share/linudex"
MENU_STYLE="$HOME/.config/linudex-quickmenu/style.css"
PANEL_STYLE="$HOME/.config/gtk-3.0/gtk.css"
STAMP="$(date +%Y%m%d-%H%M%S)"

require_file() {
    [ -f "$1" ] || { printf '[Linudex] Required file not found: %s\n' "$1" >&2; exit 1; }
}
backup_if_different() {
    local src="$1" dst="$2"
    if [ -f "$dst" ] && ! cmp -s "$src" "$dst"; then
        cp -p -- "$dst" "$dst.bak-v051-$STAMP"
    fi
}

for name in linudex-android-settings linudex-quickmenu linudex-quickmenu-indicator linudex-wifi-click; do
    require_file "$HERE/$name"
done
SRC_CSS="$REPO/configs/xfce/gtk-3.0/quickmenu.css"
SRC_WIFI="$REPO/configs/xfce/gtk-3.0/wifi-genmon.css"
SRC_ICON="$REPO/configs/xfce/assets/chevron-up.svg"
for p in "$SRC_CSS" "$SRC_WIFI" "$SRC_ICON"; do require_file "$p"; done

mkdir -p "$BIN" "$ASSETS" "$(dirname "$MENU_STYLE")" "$(dirname "$PANEL_STYLE")"
for name in linudex-android-settings linudex-quickmenu linudex-quickmenu-indicator linudex-wifi-click; do
    backup_if_different "$HERE/$name" "$BIN/$name"
    install -m 0755 "$HERE/$name" "$BIN/$name"
done
backup_if_different "$SRC_CSS" "$MENU_STYLE"
install -m 0644 "$SRC_CSS" "$MENU_STYLE"
backup_if_different "$SRC_ICON" "$ASSETS/chevron-up.svg"
install -m 0644 "$SRC_ICON" "$ASSETS/chevron-up.svg"

# Replace only our labelled CSS block. Leave every unrelated GTK/XFCE rule intact.
python3 - "$PANEL_STYLE" "$SRC_WIFI" "$STAMP" <<'PYINNER'
from pathlib import Path
import re
import shutil
import sys
panel = Path(sys.argv[1]); fragment = Path(sys.argv[2]); stamp = sys.argv[3]
marker = '/* Linudex v0.5.1 - wifi-clickable-icon */'
old = panel.read_text(encoding='utf-8') if panel.exists() else ''
block = fragment.read_text(encoding='utf-8').strip() + '\n'
pattern = re.compile(
    r'/\* Linudex v0\.5\.1 - wifi-clickable-icon \*/'
    r'(?:\s*/\*[^*]*\*/)?'
    r'\s*#genmon-14\s+\.genmon_imagebutton\s*\{[^}]*\}'
    r'\s*#genmon-14\s+\.genmon_imagebutton\s+image\s*\{[^}]*\}',
    re.S
)
if marker in old:
    updated, count = pattern.subn(lambda m: block.rstrip('\n'), old, count=1)
    if count != 1:
        raise SystemExit('[Linudex] Existing Wi-Fi CSS block could not be updated safely.')
else:
    updated = old.rstrip('\n') + '\n\n' + block
if updated != old:
    if panel.exists():
        shutil.copy2(panel, panel.with_name(panel.name + '.bak-v051-' + stamp))
    panel.write_text(updated, encoding='utf-8')
print('[Linudex] Wi-Fi indicator CSS: 75% scale.')
PYINNER
printf '%s\n' \
  '[Linudex] Utilities installed.' \
  '[Linudex] Set the Wi-Fi Genmon command to: /home/linudex/.local/bin/linudex-wifi-click' \
  '[Linudex] Add a Genmon for: /home/linudex/.local/bin/linudex-quickmenu-indicator' \
  '[Linudex] Restart the panel with: xfce4-panel -r'
