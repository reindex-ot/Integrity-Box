#!/system/bin/sh

# Define paths
PIF_JSON="/data/adb/modules/playintegrityfix/custom.pif.json"
BACKUP_JSON="${PIF_JSON}.backup" # Switched from .bak to .backup |  PIF now reserves .bak for its own use
LOG_FILE="/data/adb/Box-Brain/Integrity-Box-Logs/spoofing.log"

# Logger function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

kill_process() {
    TARGET="$1"
    PID=$(pidof "$TARGET")

    if [ -n "$PID" ]; then
        log "- Found PID(s) for $TARGET: $PID"
        kill -9 $PID
        log "- Killed $TARGET"
        log "$TARGET process killed successfully"
    else
        log "- $TARGET not running"
    fi
}

# Exit if config doesn't exist
if [ ! -f "$PIF_JSON" ]; then
    log "ERROR: $PIF_JSON not found."
    exit 1
fi

# Create backup if not already present
if [ ! -f "$BACKUP_JSON" ]; then
    cp "$PIF_JSON" "$BACKUP_JSON"
    log "Backup created at $BACKUP_JSON"
fi

# Read current spoofProps value
current_value=$(grep '"spoofProvider"' "$PIF_JSON" | grep -o '[01]')

if [ "$current_value" = "1" ]; then
    # Restore from backup
    cp "$BACKUP_JSON" "$PIF_JSON"
    log "Spoofing restored from backup"
else
    # Enable spoofing: set all to 1
    sed -i \
        -e 's/"spoofBuild": *"[01]"/"spoofBuild": "1"/' \
        -e 's/"spoofProps": *"[01]"/"spoofProps": "1"/' \
        -e 's/"spoofProvider": *"[01]"/"spoofProvider": "1"/' \
        -e 's/"spoofSignature": *"[01]"/"spoofSignature": "1"/' \
        "$PIF_JSON"
    log "Spoofing enabled: all flags set to 1"
fi

kill_process "com.google.android.gms.unstable"
kill_process "com.google.android.gms"
kill_process "com.android.vending"