#!/system/bin/sh

# Log file path
LOGFILE="/data/adb/Box-Brain/Integrity-Box-Logs/selinux.log"

# Ensure log file exists
mkdir -p "$(dirname "$LOGFILE")"
touch "$LOGFILE"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
echo "[$DATE]" >> "$LOGFILE"

# Check current SELinux mode
CURRENT_MODE=$(getenforce)

# Log and toggle
if [ "$CURRENT_MODE" = "Enforcing" ]; then
    setenforce 0
    NEW_MODE=$(getenforce)
    echo "[+] SELinux changed from Enforcing to $NEW_MODE" >> "$LOGFILE"
    echo " " >> "$LOGFILE"
    echo "SELinux is now: $NEW_MODE"
    log "SELinux set to Permissive 🔓"
elif [ "$CURRENT_MODE" = "Permissive" ]; then
    setenforce 1
    NEW_MODE=$(getenforce)
    echo "[+] SELinux changed from Permissive to $NEW_MODE" >> "$LOGFILE"
    echo " " >> "$LOGFILE"
    echo "SELinux is now: $NEW_MODE"
    log "SELinux set to Enforcing 🔐"
else
    echo "[!] Unknown SELinux state: $CURRENT_MODE" >> "$LOGFILE"
    echo " " >> "$LOGFILE"
    log "Unknown SELinux state ❓"
fi