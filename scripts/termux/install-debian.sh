#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

DISTRO_NAME="${LINUDEX_DISTRO_NAME:-linudex}"
DEBIAN_IMAGE="${LINUDEX_DEBIAN_IMAGE:-debian:13}"

log() {
    printf '[Linudex] %s\n' "$1"
}

if ! command -v proot-distro >/dev/null 2>&1; then
    printf '[Linudex] Error: proot-distro is not installed. Run setup-termux.sh first.\n' >&2
    exit 1
fi

if proot-distro login "$DISTRO_NAME" -- /bin/true >/dev/null 2>&1; then
    log "A PRoot-Distro installation named '$DISTRO_NAME' already exists."
    log 'Nothing was changed.'
    exit 0
fi

log "Installing $DEBIAN_IMAGE as '$DISTRO_NAME'..."
proot-distro install "$DEBIAN_IMAGE" --name "$DISTRO_NAME"

printf '\n'
log 'Debian installation completed.'
printf 'Enter it as root with:\n  proot-distro login %s\n' "$DISTRO_NAME"
printf 'Then run the Debian setup script from inside the distribution.\n'
