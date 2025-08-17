#!/system/bin/sh

SRC_DIR="/data/adb/Box-Brain/Font"
DEST_DIR="/data/adb/modules/integrity_box/webroot"
DEST_FILE="$DEST_DIR/mona.ttf"
LOG_DIR="/data/adb/Box-Brain/Integrity-Box-Logs"
LOG_FILE="$LOG_DIR/font.log"

# Ensure dirs exist
mkdir -p "$DEST_DIR" "$LOG_DIR"

# Timestamp
ts() {
    date +"[%Y-%m-%d %H:%M:%S]"
}

# Pick random number 1–8
rand=$(( (RANDOM % 8) + 1 ))
src_file="$SRC_DIR/custom${rand}.ttf"

# Copy to destination 
if [ -f "$src_file" ]; then
    if cp -f "$src_file" "$DEST_FILE"; then
        echo "$(ts) [OK] Copied $src_file → $DEST_FILE" | tee -a "$LOG_FILE"
        exit 0
    else
        echo "$(ts) [ERROR] Failed to copy $src_file" | tee -a "$LOG_FILE"
        exit 1
    fi
else
    echo "$(ts) [ERROR] Font $src_file not found!" | tee -a "$LOG_FILE"
    exit 1
fi