#!/system/bin/sh

MODULE="/data/adb/modules"
MODDIR="$MODULE/integrity_box"
SRC="$MODULE/integrity_box/sus.sh"
DEST_FILE="$SUSFS/action.sh"
PIF="$MODULE/playintegrityfix"
SHAMIKO="$MODULE/zygisk_shamiko"
NOHELLO="$MODULE/zygisk_nohello"
TRICKY_STORE="$MODULE/tricky_store"
SUSFS="$MODULE/susfs4ksu"
USER_SCRIPT=/data/adb/modules/integrity_box/webroot/common_scripts/user.sh

resetprop -p --delete persist.log.tag.LSPosed
resetprop -p --delete persist.log.tag.LSPosed-Bridge

# Lists for sorted display
ENABLED_LIST=""
DISABLED_LIST=""

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

# Risky Apps Detection (Count)
RISKY_APPS="com.rifsxd.ksunext
me.weishu.kernelsu
com.google.android.hmal
com.reveny.vbmetafix.service
me.twrp.twrpapp
com.termux
com.slash.batterychargelimit
io.github.vvb2060.keyattestation
io.github.muntashirakon.AppManager
io.github.vvb2060.mahoshojo
com.reveny.nativecheck
icu.nullptr.nativetest
io.github.huskydg.memorydetector
org.akanework.checker
icu.nullptr.applistdetector
io.github.rabehx.securify
krypton.tbsafetychecker
me.garfieldhan.holmes
com.byxiaorun.detector
com.kimchangyoun.rootbeerFresh.sample"

RISKY_COUNT=0

# Check risky packages
for PKG in $RISKY_APPS; do
    if pm list packages | grep -q "$PKG"; then
        RISKY_COUNT=$((RISKY_COUNT + 1))
    fi
done

# Check spoofed apps
for PKG in $(pm list packages -3 | cut -d':' -f2); do
    VERSION=$(dumpsys package "$PKG" | grep versionName | head -n 1 | awk -F= '{print $2}')
    if echo "$VERSION" | grep -qi "spoofed"; then
        RISKY_COUNT=$((RISKY_COUNT + 1))
    fi
done

# Total Modules Count
ALL_COUNT=$(find "$MODULE" -mindepth 1 -maxdepth 1 -type d | wc -l)

# Get system info
DEVICE_MODEL=$(getprop ro.product.system.model)
[ -z "$DEVICE_MODEL" ] && DEVICE_MODEL=$(getprop ro.build.product)
ANDROID_VERSION=$(getprop ro.build.version.release)
SELINUX=$(getenforce)
PATCH=$(getprop ro.build.version.security_patch)
SELINUX_RAW=$(getenforce)
if [ "$SELINUX_RAW" = "Enforcing" ]; then
    SELINUX="🟢"
else
    SELINUX="🔴"
fi

# Get Play Store version
PSTORE_VER=$(dumpsys package com.android.vending 2>/dev/null | grep -m 1 versionName | awk -F= '{print $2}' | awk '{print $1}')
[ -z "$PSTORE_VER" ] && PSTORE_VER="N/A"

# Kernel check
BANNED_KERNELS="AICP arter97 blu_spark CAF cm crDroid crdroid CyanogenMod Deathly EAS eas ElementalX Elite franco hadesKernel Lineage lineage LineageOS lineageos mokee MoRoKernel Noble Optimus SlimRoms Sultan sultan"
KERNEL_NAME=$(uname -r)
KERNEL_STATUS="🟢"
for banned in $BANNED_KERNELS; do
    if echo "$KERNEL_NAME" | grep -iq "$banned"; then
        KERNEL_STATUS="🔴"
        break
    fi
done

# TEE status check
TEE_FILE="/data/adb/tricky_store/tee_status"
if [ -f "$TEE_FILE" ]; then
    TEE_VAL=$(grep -m1 "teeBroken=" "$TEE_FILE" | cut -d'=' -f2)
    case "$TEE_VAL" in
        true)  TEE_STATUS="🔴" ;;
        false) TEE_STATUS="🟢" ;;
        *)     TEE_STATUS="🟡" ;;
    esac
else
    TEE_STATUS="⚠️"
fi

# ROM signature check
if [ -f /system/etc/security/otacerts.zip ]; then
    ROM_SIGN=$(unzip -l /system/etc/security/otacerts.zip 2>/dev/null | grep -i ".pem" | awk '{print $4}' | head -n 1)
    case "$ROM_SIGN" in
        *release*) ROM_SIGN_STATUS="🟢" ;;
        *test*)    ROM_SIGN_STATUS="🔴" ;;
        *)         ROM_SIGN_STATUS="🟡" ;;
    esac
else
    ROM_SIGN_STATUS="🟡"
fi

# Final description with new counts
ALL_MODULES="$ENABLED_LIST"
[ -n "$DISABLED_LIST" ] && ALL_MODULES="$ALL_MODULES | $DISABLED_LIST"
description="description=𝗮𝘀𝘀𝗶𝘀𝘁 𝗺𝗼𝗱𝗲: $ALL_MODULES  | 𝗞𝗲𝗿𝗻𝗲𝗹: $KERNEL_STATUS | 𝗥𝗢𝗠 𝗦𝗶𝗴𝗻: $ROM_SIGN_STATUS | 𝗦𝗘.𝗟𝗶𝗻𝘂𝘅: $SELINUX | 𝗧𝗘𝗘: $TEE_STATUS | 𝗣𝘀𝘁𝗼𝗿𝗲: $PSTORE_VER | 𝗔𝗹𝗹: $ALL_COUNT | 𝗥𝗶𝘀𝗸𝘆: $RISKY_COUNT | 𝗔𝗻𝗱𝗿𝗼𝗶𝗱: $ANDROID_VERSION | 𝗗𝗲𝘃𝗶𝗰𝗲: $DEVICE_MODEL | 𝗣𝗮𝘁𝗰𝗵: $PATCH"

# Update module.prop
sed -i "s/^description=.*/$description/" "$MODDIR/module.prop"

# Skip if stoptarget exists
[ -f /data/adb/Box-Brain/stoptarget ] && {
    exit 1
}

# Add user app package on boot
if [ -f "$USER_SCRIPT" ]; then
    sh "$USER_SCRIPT"
    exit 0
fi