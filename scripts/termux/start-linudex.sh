#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

DISTRO_NAME="${LINUDEX_DISTRO_NAME:-linudex}"
LINUX_USER="${LINUDEX_USER:-linudex}"
DISPLAY_NUMBER="${LINUDEX_DISPLAY:-:1}"
PULSE_SERVER_ADDRESS="${LINUDEX_PULSE_SERVER:-tcp:127.0.0.1}"

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

    log 'Stopping PulseAudio...'
    pulseaudio -k 2>/dev/null || true
}

trap cleanup EXIT INT TERM

for command_name in termux-x11 proot-distro pulseaudio; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        printf '[Linudex] Error: required command not found: %s\n' "$command_name" >&2
        exit 1
    fi
done

log 'Clearing stale PulseAudio server...'
pulseaudio -k 2>/dev/null || true
sleep 1

log 'Starting PulseAudio bridge...'
pulseaudio \
    --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1

sleep 1

log 'Clearing any stale Termux:X11 server...'
pkill termux-x11 2>/dev/null || true
sleep 1

log "Starting Termux:X11 on display $DISPLAY_NUMBER..."
termux-x11 "$DISPLAY_NUMBER" &
sleep 2

if command -v am >/dev/null 2>&1; then
    log 'Opening Termux:X11 Android activity...'
    am start \
        --user 0 \
        -n com.termux.x11/com.termux.x11.MainActivity \
        >/dev/null 2>&1 || true
fi

sleep 3

log "Starting Debian '$DISTRO_NAME' as user '$LINUX_USER'..."
proot-distro login "$DISTRO_NAME" \
    --user "$LINUX_USER" \
    --shared-tmp \
    --env DISPLAY="$DISPLAY_NUMBER" \
    --env PULSE_SERVER="$PULSE_SERVER_ADDRESS" \
    -- bash -lc '
        export XDG_RUNTIME_DIR=/tmp/runtime-linudex
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 700 "$XDG_RUNTIME_DIR"

        exec dbus-launch --exit-with-session xfce4-session
    '