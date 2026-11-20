#!/data/data/com.termux/files/usr/bin/bash

MONITOR="$HOME/.linudex/bin/android-monitor.sh"
DIR="$HOME/.linudex/status"
PIDFILE="$DIR/monitor.pid"

is_running() {
    [ -s "$PIDFILE" ] || return 1

    local pid
    read -r pid < "$PIDFILE" || return 1

    [[ "$pid" =~ ^[0-9]+$ ]] || return 1
    [ -r "/proc/$pid/cmdline" ] || return 1

    tr '\0' ' ' < "/proc/$pid/cmdline" |
        grep -Fq "$MONITOR"
}

case "${1:-}" in
    start)
        if is_running; then
            echo "[Linudex] Android monitor already active."
            exit 0
        fi

        [ -x "$MONITOR" ] || exit 1
        mkdir -p "$DIR"

        nohup "$MONITOR" >> "$DIR/monitor.log" 2>&1 < /dev/null &
        echo "[Linudex] Monitor initialization requested."
        ;;

    stop)
        if is_running; then
            read -r pid < "$PIDFILE"
            kill "$pid"
            echo "[Linudex] Monitor closure requested."
        elif [ -s "$PIDFILE" ]; then
            echo "[Linudex] Existing PID does not match the monitor; nothing was terminated."
            exit 1
        else
            echo "[Linudex] Monitor has already stopped."
        fi
        ;;

    status)
        if is_running; then
            cat "$PIDFILE"
        else
            echo "Monitor is not active or could not be identified."
            exit 1
        fi
        ;;

    *)
        echo "Uso: $0 {start|stop|status}"
        exit 2
        ;;
esac
