#!/system/bin/sh

SERVICE="/data/adb/service.d"
mkdir -p "$SERVICE"

cat <<'EOF' > "$SERVICE/debug.sh"
#!/system/bin/sh

# Exit if /data/adb/Box-Brain/cam exists
[ -f /data/adb/Box-Brain/cam ] && exit 0

L="/data/adb/Box-Brain/Integrity-Box-Logs/debug.log"

# Logger
meow() {
    echo "$1" | tee -a "$L"
}

resetprop -p --delete persist.log.tag.LSPosed
resetprop -p --delete persist.log.tag.LSPosed-Bridge

# Get current fingerprint
fp=$(getprop ro.build.fingerprint)

echo "$fp" | grep -q "userdebug"
if [ $? -eq 0 ]; then
    meow "Debug fingerprint detected. Cleaning it up..."

    fp_clean=${fp/userdebug/user}
    fp_clean=${fp_clean/test-keys/release-keys}
    fp_clean=${fp_clean/dev-keys/release-keys}

    resetprop ro.build.fingerprint "$fp_clean"
    resetprop ro.build.type "user"
    resetprop ro.build.tags "release-keys"

    meow "Cleaned fingerprint applied:"
    meow "$fp_clean"
    meow " "
    meow " "
else
    meow "Fingerprint already clean. No changes made."
fi
EOF

chmod 755 "$SERVICE/debug.sh"
exit 0