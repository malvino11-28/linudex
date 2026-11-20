#!/usr/bin/env bash

set -euo pipefail

log() {
    printf '[Linudex] %s\n' "$1"
}

if [ "$(id -u)" -eq 0 ]; then
    SUDO=''
else
    SUDO='sudo'
fi

log 'Updating Debian package indexes...'
$SUDO apt update

log 'Installing essential desktop applications...'
$SUDO apt install -y \
    firefox-esr \
    evince \
    vlc \
    ristretto \
    mousepad \
    galculator \
    xarchiver \
    thunar-archive-plugin \
    unzip \
    zip \
    p7zip-full

log 'Installing LibreOffice components...'
$SUDO apt install -y \
    libreoffice-writer \
    libreoffice-calc \
    libreoffice-impress \
    libreoffice-gtk3 \
    libreoffice-l10n-pt-br \
    hunspell-pt-br

log 'Installing document-compatible fonts...'
$SUDO apt install -y \
    fonts-crosextra-carlito \
    fonts-crosextra-caladea \
    fonts-liberation \
    fonts-noto

printf '\n'
log 'Essential applications installation completed.'