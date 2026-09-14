#!/data/data/com.termux/files/usr/bin/bash
set -u

log() {
    printf '[Linudex] %s\n' "$1"
}

log 'Stopping XFCE session...'
pkill -f xfce4-session 2>/dev/null || true
sleep 1

log 'Stopping Termux:X11 server...'
pkill termux-x11 2>/dev/null || true

if command -v am >/dev/null 2>&1; then
    am broadcast \
        -a com.termux.x11.ACTION_STOP \
        -p com.termux.x11 \
        >/dev/null 2>&1 || true
fi

log 'Stopping PulseAudio...'
pulseaudio -k 2>/dev/null || true

log 'Linudex stop request completed.'