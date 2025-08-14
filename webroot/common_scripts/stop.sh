#!/system/bin/sh

file="/sdcard/stop"
shamiko="/data/adb/shamiko/whitelist"
nohello="/data/adb/nohello/whitelist"

# Create the stop file
if ! touch "$file"; then
  echo "❌ Failed to create stop file"
  exit 1
fi

# Delete Shamiko whitelist if it exists
[ -f "$shamiko" ] && {
  rm -f "$shamiko"
  echo "🛑 Shamiko auto-whitelist stopped"
}

# Delete NoHello whitelist if it exists
[ -f "$nohello" ] && {
  rm -f "$nohello"
  echo "🛑 NoHello auto-whitelist stopped"
}

exit 0