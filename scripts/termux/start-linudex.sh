#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

DISTRO_NAME="${LINUDEX_DISTRO_NAME:-linudex}"
LINUX_USER="${LINUDEX_USER:-linudex}"
DISPLAY_NUMBER="${LINUDEX_DISPLAY:-:1}"

log() {
    printf '[Linudex] %s\n' "$1"
}

cleanup() {
    log 'Stopping Termux:X11...'
    pkill termux-x11 2>/dev/null || true

    if command -v am >/dev/null 2>&1; then
        am broadcast \
            -a com.termux.x11.ACTION_STOP \
            -p com.termux.x11 \
            >/dev/null 2>&1 || true
    fi
}

trap cleanup EXIT INT TERM

for command_name in termux-x11 proot-distro; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        printf '[Linudex] Error: required command not found: %s\n' "$command_name" >&2
        exit 1
    fi
done

log 'Clearing any stale Termux:X11 server...'
pkill termux-x11 2>/dev/null || true
sleep 1

log "Starting Termux:X11 on display $DISPLAY_NUMBER..."
termux-x11 "$DISPLAY_NUMBER" &
sleep 2

log "Starting Debian '$DISTRO_NAME' as user '$LINUX_USER'..."
proot-distro login "$DISTRO_NAME" \
    --user "$LINUX_USER" \
    --shared-tmp \
    --env DISPLAY="$DISPLAY_NUMBER" \
    -- bash -lc '
        export XDG_RUNTIME_DIR=/tmp/runtime-linudex
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 700 "$XDG_RUNTIME_DIR"
        exec dbus-launch --exit-with-session xfce4-session
    '
