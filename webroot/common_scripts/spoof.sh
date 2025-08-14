#!/system/bin/sh

# Define paths
LOG_FILE="/data/adb/Box-Brain/Integrity-Box-Logs/spoofing.log"

# Define prop files
PROP_FILE_1="/data/adb/modules/playintegrityfix/pif.prop"
PROP_FILE_2="/data/adb/pif.prop"

# Logger function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

log " "
log " "

FOUND_ANY=0

# Function to toggle boolean props
toggle_bool() {
    file="$1"
    key="$2"
    value=$(grep -E "^$key=" "$file" | cut -d'=' -f2)

    if [ "$value" = "true" ]; then
        sed -i "s/^$key=true/$key=false/" "$file"
        log "$file: $key → false"
    elif [ "$value" = "false" ]; then
        sed -i "s/^$key=false/$key=true/" "$file"
        log "$file: $key → true"
    else
        log "$file: $key not found or not boolean"
    fi
}

# Force key to false
force_false() {
    file="$1"
    key="$2"
    if grep -q "^$key=" "$file"; then
        sed -i "s/^$key=.*/$key=false/" "$file"
    else
        echo "$key=false" >> "$file"
    fi
    log "$file: $key → forced to false"
}

# Header
log "──────── TOGGLE SPOOF FLAGS ────────"

# Process both files
for PIF_PROP in "$PROP_FILE_1" "$PROP_FILE_2"; do
    if [ -f "$PIF_PROP" ]; then
        FOUND_ANY=1

        # Backup
        BACKUP="$PIF_PROP.bak"
        cp -f "$PIF_PROP" "$BACKUP"
        log "Backup created: $BACKUP"

        # Toggle spoof flags
        toggle_bool "$PIF_PROP" "spoofProvider"
        toggle_bool "$PIF_PROP" "spoofSignature"
        toggle_bool "$PIF_PROP" "spoofProps"

        # Force false
        force_false "$PIF_PROP" "DEBUG"
        force_false "$PIF_PROP" "spoofVendingSdk"
    fi
done

# If no files found, exit
if [ "$FOUND_ANY" -eq 0 ]; then
    log "❌ No spoofing prop files found"
    log "This feature is only for PIF inject"
    exit 1
fi

# Determine spoofing status from the first valid file
if [ -f "$PROP_FILE_1" ]; then
    spoof_status=$(grep "^spoofProvider=" "$PROP_FILE_1" | cut -d'=' -f2)
elif [ -f "$PROP_FILE_2" ]; then
    spoof_status=$(grep "^spoofProvider=" "$PROP_FILE_2" | cut -d'=' -f2)
else
    spoof_status="unknown"
fi

# Popup status
if [ "$spoof_status" = "true" ]; then
    log "✅ Spoofing enabled"
    log "Popup: Spoofing enabled"
else
    log "⚠️ Spoofing disabled"
    log "Popup: Spoofing disabled"
fi

# Footer
log "✅ Toggling complete"
log " "
log " "
exit 0
