#!/system/bin/sh

# Define paths
PIF_JSON="/data/adb/modules/playintegrityfix/custom.pif.json"
BACKUP_JSON="${PIF_JSON}.bak"
LOG_FILE="/data/adb/Integrity-Box-Logs/spoofing.log"

# Popup function
popup() {
    am start -a android.intent.action.MAIN \
        -e mona "$@" \
        -n popup.toast/meow.helper.MainActivity >/dev/null 2>&1
    sleep 0.5
}

# Logger function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Exit if config doesn't exist
if [ ! -f "$PIF_JSON" ]; then
    log "ERROR: $PIF_JSON not found."
    popup "You're not using PIF Fork"
    exit 1
fi

# Create backup if not already present
if [ ! -f "$BACKUP_JSON" ]; then
    cp "$PIF_JSON" "$BACKUP_JSON"
    log "Backup created at $BACKUP_JSON"
    popup "Backup created"
fi

# Read current spoofProps value
current_value=$(grep '"spoofProps"' "$PIF_JSON" | grep -o '[01]')

if [ "$current_value" = "1" ]; then
    # Restore from backup
    cp "$BACKUP_JSON" "$PIF_JSON"
    log "Spoofing restored from backup"
    popup "Spoofing restored"
else
    # Enable spoofing: set all to 1
    sed -i \
        -e 's/"spoofProps": *"[01]"/"spoofProps": "1"/' \
        -e 's/"spoofProvider": *"[01]"/"spoofProvider": "1"/' \
        -e 's/"spoofSignature": *"[01]"/"spoofSignature": "1"/' \
        "$PIF_JSON"
    log "Spoofing enabled: all flags set to 1"
    popup "Spoofing enabled"
fi