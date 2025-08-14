#!/system/bin/sh

H_FILE="/data/adb/VerifiedBootHash/VerifiedBootHash.txt"
PROP="ro.boot.vbmeta.digest"
LOG="/data/adb/Box-Brain/Integrity-Box-Logs/hash.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

clean() {
    echo "$1" | tr -d '[:space:]' | tr 'A-Z' 'a-z'
}

current_prop() {
    getprop "$PROP" | clean
}

saved_hash() {
    [ -f "$H_FILE" ] && sed '/^#/d; /^$/d' "$H_FILE" | clean
}

if [ ! -f "$H_FILE" ]; then
    log "SusFs is not installed"
    exit 1
fi

case "$1" in
  get)
    CUR=$(current_prop)
    SAVED=$(saved_hash)
    echo "$CUR"
    echo "$SAVED"
    ;;

  set)
    HASH=$(clean "$2")

    if [ -z "$HASH" ]; then
        log "✦ Invalid hash"
        log "Empty hash passed to set"
        exit 1
    fi

    # Save and apply
    echo "$HASH" > "$H_FILE"
    chmod 644 "$H_FILE"
    resetprop -n "$PROP" "$HASH"

    log "✦ Saved and set: $HASH"
    log "Saved and applied new hash"
    ;;

  clear)
#    rm -f "$H_FILE"
    resetprop -n "$PROP" ""
    log "✦ Hash cleared and property reset"
    log "Hash cleared"
    ;;

  *)
    log "Usage: $0 [get | set <hash> | clear]"
    echo "Usage: $0 [get | set <hash> | clear]"
    exit 1
    ;;
esac