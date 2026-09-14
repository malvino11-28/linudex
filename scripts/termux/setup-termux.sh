#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

log() {
    printf '[Linudex] %s\n' "$1"
}

log 'Updating Termux repositories...'
pkg update -y

log 'Upgrading installed Termux packages...'
pkg upgrade -y

log 'Installing base packages...'
pkg install -y \
    git \
    curl \
    wget \
    nano \
    openssh \
    proot-distro \
    x11-repo

log 'Refreshing package indexes after enabling the X11 repository...'
pkg update -y

log 'Installing Termux:X11 and PulseAudio...'
pkg install -y \
    termux-x11-nightly \
    pulseaudio

printf '\n'

log 'Termux host setup completed.'

printf '%s\n' \
    'The Android Termux:X11 APK is a separate component and must be installed manually.' \
    'If Termux was installed from F-Droid, use the non-sharedUid Termux:X11 APK.' \
    'Termux:Boot and Termux:Widget are optional Android plugins used by Linudex v0.2.0.'