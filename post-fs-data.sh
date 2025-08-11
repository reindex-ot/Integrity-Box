#!/system/bin/sh
L="/data/adb/Integrity-Box-Logs/post.log"
MODULE="/data/adb/modules"
MODDIR="$MODULE/integrity_box"
SRC="$MODULE/integrity_box/sus.sh"
DEST_FILE="$SUSFS/action.sh"
PIF="$MODULE/playintegrityfix"
SHAMIKO="$MODULE/zygisk_shamiko"
NOHELLO="$MODULE/zygisk_nohello"
TRICKY_STORE="$MODULE/tricky_store"
SUSFS="$MODULE/susfs4ksu"

log() { echo -e "$1" | tee -a "$L"; }

#if [ -e /data/adb/modules/integrity_box/disable ]; then
#    rm -rf /data/adb/modules/integrity_box/disable
#    log "Module re-enabled successfully"
#else
    log "Status 1"
#fi

if [ -e /data/adb/shamiko/whitelist ]; then
    rm -rf /data/adb/shamiko/whitelist
    log "Removed whitelist to avoid bootloop"
else
    log "Status 2"
fi

if [ -e /data/adb/modules/Integrity-Box ]; then
    rm -rf /data/adb/modules/Integrity-Box
    log "Removed old integrity box module"
else
    log "Status 3"
fi

# Lists for sorted display
ENABLED_LIST=""
DISABLED_LIST=""

# Append helper
append_item() {
    if [ -z "$1" ]; then
        echo "$2"
    else
        echo "$1 | $2"
    fi
}

# Check and sort modules
[ -d "$SHAMIKO" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "Shamiko ✅") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "Shamiko ❌")
[ -d "$TRICKY_STORE" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "TrickyStore ✅") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "TrickyStore ❌")
[ -d "$NOHELLO" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "NoHello ✅") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "NoHello ❌")
[ -d "$SUSFS" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "SusFS ✅") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "SusFS ❌")
[ -d "$PIF" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "PIF ✅") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "PIF ❌")

# Get system info
DEVICE_MODEL=$(getprop ro.product.system.model)
[ -z "$DEVICE_MODEL" ] && DEVICE_MODEL=$(getprop ro.build.product)
ANDROID_VERSION=$(getprop ro.build.version.release)
SELINUX=$(getenforce)
PATCH=$(getprop ro.build.version.security_patch)

# Combine and format final description
ALL_MODULES="$ENABLED_LIST"
[ -n "$DISABLED_LIST" ] && ALL_MODULES="$ALL_MODULES | $DISABLED_LIST"
description="description=𝗮𝘀𝘀𝗶𝘀𝘁 𝗺𝗼𝗱𝗲: $ALL_MODULES | 𝗔𝗻𝗱𝗿𝗼𝗶𝗱: $ANDROID_VERSION | 𝗦𝗘.𝗟𝗶𝗻𝘂𝘅: $SELINUX | 𝗗𝗲𝘃𝗶𝗰𝗲: $DEVICE_MODEL | 𝗣𝗮𝘁𝗰𝗵: $PATCH"

# Update module.prop
sed -i "s/^description=.*/$description/" "$MODDIR/module.prop"

 sed -i 's/^author=.*/author=𝗠𝗘𝗢𝗪𝗻𝗮 💅 || tg@MeowDump/' "$MODDIR/module.prop"
 log "Status 4"

# Randomize banner image (1 to 8)
#RANDOM_NUM=$(( (RANDOM % 8) + 1 ))
#sed -i "s|^banner=.*|banner=https://raw.githubusercontent.com/MeowDump/MeowDump/Banner/mona$RANDOM_NUM.png|" "$MODDIR/module.prop"

chmod 755 /data/adb/service.d/debug.sh
log "Status 5"

# Create temp file
cat <<EOF > /data/adb/Integrity-Box-Logs/.verify
YOURmindISpowerfulWHENyouFILLitwithPOSITIVITYyourLIFEstartstoCHANGE
EOF

log "Status 7"