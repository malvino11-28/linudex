#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

LOG_DIR="$HOME/.linudex/logs"
LOG_FILE="$LOG_DIR/virgl.log"
VIRGL_SOCKET="$TMPDIR/.virgl_test"

log() {
    printf '[Linudex GPU] %s\n' "$1"
}

if ! command -v virgl_test_server_android >/dev/null 2>&1; then
    log 'Error: VirGL is not installed.'
    exit 1
fi

EXISTING_PID=$(pgrep -f '(^|/)virgl_test_server_android([[:space:]]|$)' | head -n 1 || true)

if [ -n "$EXISTING_PID" ]; then
    EXISTING_CMD=$(ps -p "$EXISTING_PID" -o args=)

    if [[ "$EXISTING_CMD" == *"--angle-gl"* ]] &&
       [ -S "$VIRGL_SOCKET" ]; then
        log 'VirGL + ANGLE is already running.'
        exit 0
    fi

    log 'Error: another VirGL instance is active.'
    log 'Stop it before changing the graphics backend.'
    exit 1
fi

mkdir -p "$LOG_DIR"

log 'Starting VirGL + ANGLE (OpenGL ES)...'

nohup virgl_test_server_android --angle-gl \
    > "$LOG_FILE" 2>&1 < /dev/null &

VIRGL_PID=$!
VIRGL_READY=false

for ((attempt=1; attempt<=40; attempt++)); do
    if ! kill -0 "$VIRGL_PID" 2>/dev/null; then
        break
    fi

    if [ -S "$VIRGL_SOCKET" ]; then
        VIRGL_READY=true
        break
    fi

    sleep 0.25
done

if [ "$VIRGL_READY" != true ]; then
    log 'Error: VirGL did not become ready.'
    log "Check: $LOG_FILE"
    exit 1
fi

log "VirGL server started (PID $VIRGL_PID)."
log 'Graphics backend: ANGLE / OpenGL ES.'
log 'Socket detected successfully.'
