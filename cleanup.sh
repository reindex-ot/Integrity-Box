#!/system/bin/sh
MODDIR="/data/adb/modules_update/integrity_box"
MODDIR2="/data/adb/modules/integrity_box"
F="/data/adb/tricky_store/keybox.xml"
T="/data/adb/tricky_store/keybox.xml.tmp"
L="/data/adb/Box-Brain/Integrity-Box-Logs/remove.log"
X="create,evolve,repeat,win,hellomona"

log() {
    echo "- $1" >> "$L"
}

delete_if_exist() {
    path="$1"
    if [ -e "$path" ]; then
        rm -rf "$path"
        log "Deleted: $path"
    fi
}

mkdir -p "$(dirname "$L")"
touch "$L"
{
    echo ""
    echo "••••••• Cleanup Started •••••••"

# Remove banner for Magisk users
#if [ -f /data/adb/magisk/magisk ]; then
#    log "Magisk detected."

#    if [ -d "$MODDIR" ]; then
#        rm -f "$MODDIR/meow"
#        log "Removed meow banner from $MODDIR"
#    else
#        log "Skipped $MODDIR (ran in installed state)"
#    fi

#    if [ -d "$MODDIR2" ]; then
#        rm -f "$MODDIR2/meow"
#    else
#        log "Skipped $MODDIR2 (folder not found)"
#    fi
#else
#    log "Magisk not detected. Skipping banner removal."
#fi

# Remove meow helper
if pm list packages | grep -q "meow.helper"; then
    pm uninstall meow.helper >/dev/null 2>&1
fi

# Remove popup toaster
if pm list packages | grep -q "popup.toast"; then
    pm uninstall popup.toast >/dev/null 2>&1
fi

# Remove spoofed popup toaster
if pm list packages | grep -q "imagine.detecting.ablank.app"; then
    pm uninstall imagine.detecting.ablank.app >/dev/null 2>&1
fi

    if [ ! -f "$F" ]; then
        log "File not found: $F"
        echo "••••••• Cleanup Aborted •••••••"
        exit 0
    fi

    log "Removing leftover files"

Z="$(cat "$F")"

Y=""
FIRST=1
IFS=','

for LINE in $(echo "$Z"); do
    for WORD in $X; do
        LINE="${LINE//$WORD/}"
    done
    if [ "$FIRST" -eq 1 ]; then
        Y="$LINE"
        FIRST=0
    else
        Y="$Y
$LINE"
    fi
done

IFS="$OLD_IFS"

printf "%s\n" "$Y" > "$T"
mv "$T" "$F"

    log "Deleting known leftover files..."
    delete_if_exist /data/adb/Integrity-Box/openssl
    delete_if_exist /data/adb/Integrity-Box/libssl.so.3
    delete_if_exist /data/adb/modules/Integrity-Box/system/bin/openssl
    delete_if_exist /data/local/tmp/keybox_downloader
    delete_if_exist /data/adb/modules_update/integrity_box/keybox_downloader.sh
    delete_if_exist /data/adb/modules_update/integrity_box/Toaster.apk
    delete_if_exist /data/adb/integrity_box_verify
    delete_if_exist /data/adb/modules/AntiBloat/system/product/app/MeowAssistant/MeowAssistant.apk
    delete_if_exist /data/adb/modules/PixelLauncher/system/product/app/MeowAssistant/MeowAssistant.apk
    delete_if_exist /data/adb/modules/PowerSaverPro/system/product/app/PowerSaverPro/PowerSaverPro.apk
	delete_if_exist /data/adb/modules/integrity_box/system/product/app/Toaster/Toaster.apk
	delete_if_exist /data/adb/modules_update/integrity_box/verify.sh
	delete_if_exist /data/adb/Integrity-Box-Logs
	delete_if_exist /data/adb/service.d/debug.sh

    echo "••••••• Cleanup Ended •••••••"
    echo ""
} >> "$L" 2>&1