#!/usr/bin/env bash
set -euo pipefail

LINUX_USER="${LINUDEX_USER:-linudex}"

log() {
    printf '[Linudex] %s\n' "$1"
}

if [ "$(id -u)" -ne 0 ]; then
    printf '[Linudex] Error: this script must be run as root inside Debian.\n' >&2
    exit 1
fi

log 'Updating Debian package indexes...'
apt update

log 'Upgrading installed Debian packages...'
DEBIAN_FRONTEND=noninteractive apt upgrade -y

log 'Installing base Debian packages...'
DEBIAN_FRONTEND=noninteractive apt install -y \
    sudo \
    git \
    curl \
    wget \
    nano \
    ca-certificates \
    locales \
    procps \
    htop \
    file \
    unzip \
    zip

if id "$LINUX_USER" >/dev/null 2>&1; then
    log "User '$LINUX_USER' already exists."
else
    log "Creating user '$LINUX_USER'."
    printf 'You will be asked to define the user password and account details.\n'
    adduser "$LINUX_USER"
fi

log "Adding '$LINUX_USER' to the sudo group..."
usermod -aG sudo "$LINUX_USER"

log 'Creating an explicit sudoers rule for PRoot-Distro sessions...'
SUDOERS_TMP="$(mktemp)"
printf '%s ALL=(ALL:ALL) ALL\n' "$LINUX_USER" > "$SUDOERS_TMP"
chmod 0440 "$SUDOERS_TMP"
visudo -cf "$SUDOERS_TMP"
install -m 0440 "$SUDOERS_TMP" "/etc/sudoers.d/$LINUX_USER"
rm -f "$SUDOERS_TMP"
visudo -cf "/etc/sudoers.d/$LINUX_USER"

printf '\n'
log 'Debian base setup completed.'
printf 'From Termux, log in as the normal user with:\n'
printf '  proot-distro login linudex --user %s\n' "$LINUX_USER"
