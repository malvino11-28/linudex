#!/data/data/com.termux/files/usr/bin/bash

LOG_FILE="$HOME/linudex-boot.log"

exec >> "$LOG_FILE" 2>&1

printf '\n=== Linudex boot: %s ===\n' "$(date)"

termux-wake-lock

echo "[Boot] Waiting for Android boot completion..."

until [ "$(getprop sys.boot_completed 2>/dev/null)" = "1" ]; do
    sleep 2
done

echo "[Boot] Android boot completed."

echo "[Boot] Waiting for graphical environment..."
sleep 20

echo "[Boot] Starting Linudex..."

exec "$HOME/start-linudex.sh"