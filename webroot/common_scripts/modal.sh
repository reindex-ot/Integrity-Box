#!/system/bin/sh
LOGFILE="/data/adb/Integrity-Box-Logs/modal.log"
SCRIPT_JS="/data/adb/modules/integrity_box/webroot/script.js"
TEMP_JS="${SCRIPT_JS}.tmp"

# Logging function
log() { echo -e "$1" | tee -a "$LOGFILE"; }

# Toaster 
popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n imagine.detecting.ablank.app/mona.meow.MainActivity > /dev/null
    sleep 0.5
}

# check
[ ! -f "$SCRIPT_JS" ] && log "script.js not found!" && exit 1

if grep -q 'setTimeout(closeModal, *[0-9]*);' "$SCRIPT_JS"; then
  sed '/setTimeout(closeModal, *[0-9]*);/d' "$SCRIPT_JS" > "$TEMP_JS"
  mv "$TEMP_JS" "$SCRIPT_JS"
  log "Auto-close function disabled ❌"
  popup "Stopped"
else
  awk '
  BEGIN { inserted=0 }
  {
    print $0
    if (!inserted && $0 ~ /modalOutput\.innerHTML.*replace.*;/) {
      print "          setTimeout(closeModal, 10000);"
      inserted=1
    }
  }' "$SCRIPT_JS" > "$TEMP_JS"
  mv "$TEMP_JS" "$SCRIPT_JS"
  log "Auto-close function enabled ✅"
  popup "Back to default settings"
fi

exit 0