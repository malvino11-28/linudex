#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
pkg-config --print-errors --exists libxfce4panel-2.0 gtk+-3.0 gio-2.0 || {
    echo 'Build dependencies unavailable. Install build-essential pkg-config libgtk-3-dev libxfce4panel-2.0-dev libxfce4ui-2-dev.' >&2
    exit 1
}
gcc -std=c11 -O2 -fPIC -shared -Wall -Wextra -o liblinudexsearch.so linudexsearch.c \
    $(pkg-config --cflags --libs libxfce4panel-2.0 gtk+-3.0 gio-2.0)
echo 'Build completed: liblinudexsearch.so'
