#!/system/bin/sh

F="/data/adb/tricky_store/keybox.xml"
T="/data/adb/tricky_store/keybox.xml.tmp"
L="/data/adb/Integrity-Box-Logs/remove.log"
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

    if [ ! -f "$F" ]; then
        log "File not found: $F"
        echo "••••••• Cleanup Aborted •••••••"
        exit 1
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

    echo "••••••• Cleanup Ended •••••••"
    echo ""
} >> "$L" 2>&1