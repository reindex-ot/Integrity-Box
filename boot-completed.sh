#!/system/bin/sh

T=/data/adb/tricky_store/target.txt
S=/data/adb/tricky_store/tee_status
[ -d "${T%/*}" ] || exit 0

rm -f "$T"
b=false; [ -f "$S" ] && b=$(grep ^teeBroken= "$S" | cut -d= -f2)

suffix() { [ "$b" = true ] && echo !; }

{
  echo "# UPDATED ON BOOT $(date)"
  for p in android com.android.vending com.google.android.gms com.reveny.nativecheck \
           io.github.vvb2060.keyattestation io.github.qwq233.keyattestation \
           io.github.vvb2060.mahoshojo icu.nullptr.nativetest \
           com.google.android.contactkeys com.google.android.gsf \
           com.google.android.ims com.google.android.safetycore; do
    echo "$p$(suffix)"
  done
  for f in -3 -s; do
    pm list packages $f | cut -d: -f2 | while read p; do
      grep -q "^$p" "$T" 2>/dev/null || echo "$p$(suffix)"
    done
  done
} > "$T"

# Set log level for LSPosed
#tags=("LSPosed" "LSPosed-Bridge")
#for tag in "${tags[@]}"; do
#    setprop persist.log.tag."$tag" S
#done

# Define popup
#popup() {
#    am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity > /dev/null
#    sleep 0.5
#}

resetprop -p --delete persist.log.tag.LSPosed
resetprop -p --delete persist.log.tag.LSPosed-Bridge

# su -c 'getprop | grep -E "pihook|pixelprops" | sed -E "s/^\[(.*)\]:.*/\1/" | while IFS= read -r prop; do resetprop -p -d "$prop"; done'

# Wait for system to stabilize before setting SELinux
#sleep 10

# Try to set SELinux to enforcing if permissive 
#if command -v setenforce >/dev/null 2>&1; then
#    current=$(getenforce)
#    if [ "$current" != "Enforcing" ]; then
#        setenforce 1
#        popup "Spoofed Selinux to ENFORCING"
#    fi
#fi
exit 0
