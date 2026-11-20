#!/data/data/com.termux/files/usr/bin/bash

umask 077
DIR="$HOME/.linudex/status"
mkdir -p "$DIR"

if [ -f "$DIR/monitor.pid" ]; then
    OLD_PID=$(cat "$DIR/monitor.pid")
    if [[ "$OLD_PID" =~ ^[0-9]+$ ]] &&
       kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Monitor já está ativo: PID $OLD_PID"
        exit 0
    fi
fi

echo "$$" > "$DIR/monitor.pid"

cleanup() {
    rm -f "$DIR/monitor.pid"
    rm -f "$DIR"/.*.tmp."$$"
}
trap cleanup EXIT

update_status() {
    local command="$1"
    local name="$2"
    local tmp="$DIR/.$name.tmp.$$"

    if timeout 15s "$command" > "$tmp" 2>/dev/null &&
       grep -q '^[[:space:]]*{' "$tmp"; then
        mv -f "$tmp" "$DIR/$name.json"
    else
        rm -f "$tmp"
    fi
}

while true; do
    update_status termux-battery-status battery
    update_status termux-wifi-connectioninfo wifi
    sleep 45
done
