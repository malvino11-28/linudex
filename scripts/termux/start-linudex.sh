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
	"$HOME/.linudex/bin/android-monitor-control.sh" stop || true
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

log 'Clearing stale PulseAudio runtime state...'
rm -rf "$TMPDIR/pulse"

log 'Starting PulseAudio bridge...'

PULSE_STARTED=false

for attempt in 1 2 3; do
	log "PulseAudio attempt $attempt/3..."

	pulseaudio -k 2>/dev/null || true
	rm -rf "$TMPDIR/pulse"

	if pulseaudio \
		--start \
		--load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
		--exit-idle-time=-1
	then
		PULSE_STARTED=true
		break
	fi

	sleep 3
done

if [ "$PULSE_STARTED" != true ]; then
	log 'Error: PulseAudio failed to start.'
	exit 1
fi 

log 'Clearing any stale Termux:X11 server...'
pkill termux-x11 2>/dev/null || true
sleep 1

log "Starting Termux:X11 on display $DISPLAY_NUMBER..."
termux-x11 "$DISPLAY_NUMBER" &
X11_PID=$!

X11_DISPLAY="${DISPLAY_NUMBER#:}"
X11_DISPLAY="${X11_DISPLAY%%.*}"
X11_SOCKET="$TMPDIR/.X11-unix/X${X11_DISPLAY}"

log 'Waiting for Termux:X11 socket...'
X11_READY=false
for ((attempt=1; attempt<=40; attempt++)); do
    if [ -S "$X11_SOCKET" ]; then
        X11_READY=true
        break
    fi
    if ! kill -0 "$X11_PID" 2>/dev/null; then
        break
    fi
    sleep 0.25
done

if [ "$X11_READY" != true ]; then
    log 'Error: Termux:X11 socket was not created.'
    exit 1
fi

log 'Termux:X11 socket detected.'

if command -v am >/dev/null 2>&1; then
    log 'Opening Termux:X11 Android activity...'

    X11_ACTIVITY_STARTED=false

    for attempt in 1 2 3; do
        log "Termux:X11 activity attempt $attempt/3..."

        if am start \
            --user 0 \
            -W \
            -n com.termux.x11/com.termux.x11.MainActivity
        then
            X11_ACTIVITY_STARTED=true
            break
        fi

        if [ "$attempt" -lt 3 ]; then
            sleep 3
        fi
    done

    if [ "$X11_ACTIVITY_STARTED" != true ]; then
        log 'Warning: failed to open Termux:X11 activity.'
    fi
fi

# v0.5
log 'Starting Android status monitor...'
"$HOME/.linudex/bin/android-monitor-control.sh" start ||
	log 'Warning: Android monitor could not be started.'

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
		unset LC_ALL LC_CTYPE
		export LANG=pt_BR.UTF-8		
		exec dbus-launch --exit-with-session xfce4-session
	'
