#!/system/bin/sh

MODPATH=${MODPATH:-/data/adb/modules_update/integrity_box}
VERIFY_TEMP_DIR="/data/adb/integrity_box_verify"
LOG="/data/adb/Box-Brain/Integrity-Box-Logs/verification.log"

# Clean temp dir
rm -rf "$VERIFY_TEMP_DIR"
mkdir -p "$VERIFY_TEMP_DIR"

# Logger
log() {
    echo "$1" | tee -a "$LOG"
}

abort_verify() {
  log "----------------------------------------------"
  log " "
  log "   ❌ Error: File integrity compromised.⚠️"
  log " ✦ Please download the module again"
  log "from its release source to restore it."
  sleep 4
  am start -a android.intent.action.VIEW -d https://t.me/MeowRedirect >/dev/null 2>&1
  log " "
  log "----------------------------------------------"
  log " "
  exit 1
}

verify_file() {
  local relpath="$1"
  local file="$MODPATH/$relpath"
  local hashfile="$file.sha256"

  [ ! -f "$file" ] && log " ✦ Missing: $relpath" && abort_verify
  [ ! -f "$hashfile" ] && log " ✦ Missing hash: $relpath.sha256" && abort_verify

  local expected actual
  expected=$(cut -d' ' -f1 < "$hashfile")
  actual=$(sha256sum "$file" | cut -d' ' -f1)

  [ "$expected" != "$actual" ] && log "Corrupt: $relpath" && abort_verify

  log " ✦ Verified: $relpath" > /dev/null 2>&1
  mkdir -p "$VERIFY_TEMP_DIR/$(dirname "$relpath")"
  cp -af "$file" "$VERIFY_TEMP_DIR/$relpath"

  # ✅ Delete the hash file after successful verification
  rm -f "$hashfile"
}

# Find all files (excluding *.sha256)
ALL_FILES=$(cd "$MODPATH" && find . -type f ! -name "*.sha256" | cut -c3-)

for relpath in $ALL_FILES; do
  verify_file "$relpath"
done

log " ✦ Verification completed successfully."
log " "