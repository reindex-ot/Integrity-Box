#!/system/bin/sh

# Log file path
LOGFILE="/data/adb/Integrity-Box-Logs/selinux.log"

# Popup function using meow.helper
popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n imagine.detecting.ablank.app/mona.meow.MainActivity > /dev/null
    sleep 0.5
}

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
    popup "SELinux set to Permissive 🔓"
elif [ "$CURRENT_MODE" = "Permissive" ]; then
    setenforce 1
    NEW_MODE=$(getenforce)
    echo "[+] SELinux changed from Permissive to $NEW_MODE" >> "$LOGFILE"
    echo " " >> "$LOGFILE"
    echo "SELinux is now: $NEW_MODE"
    popup "SELinux set to Enforcing 🔐"
else
    echo "[!] Unknown SELinux state: $CURRENT_MODE" >> "$LOGFILE"
    echo " " >> "$LOGFILE"
    popup "Unknown SELinux state ❓"
fi