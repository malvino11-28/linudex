#!/usr/bin/env bash
set -euo pipefail

log() {
    printf '[Linudex] %s\n' "$1"
}

if command -v sudo >/dev/null 2>&1; then
    SUDO='sudo'
elif [ "$(id -u)" -eq 0 ]; then
    SUDO=''
else
    printf '[Linudex] Error: sudo is unavailable and the current user is not root.\n' >&2
    exit 1
fi

log 'Updating Debian package indexes...'
$SUDO apt update

log 'Installing the v0.1 graphical desktop packages...'
$SUDO apt install -y \
    xfce4 \
    dbus-x11 \
    firefox-esr

printf '\n'
log 'Desktop packages installed.'
printf '%s\n' \
    'Termux:X11 must be running on the Android/Termux side before XFCE can open.' \
    'Use the Termux start-linudex.sh script to launch the complete graphical session.'
