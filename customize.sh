#!/system/bin/sh
MODDIR=${0%/*}
ButterChicken01="/data/adb/modules/tricky_store"
ButterChicken02="/data/adb/tricky_store"
ButterChicken03="/data/adb/Box-Brain/Integrity-Box-Logs"
ButterChicken04="$ButterChicken03/Installation.log"
ButterChicken05="/data/adb/modules_update/integrity_box"
ButterChicken06="$ButterChicken02/target.txt"
ButterChicken07="/data/adb/modules/playintegrityfix"
ButterChicken08="$ButterChicken07/module.prop"
ButterChicken09="2025-08-01"
ButterChicken10="$ButterChicken02/security_patch.txt"
ButterChicken11="$ButterChicken02/tee_status"
ButterChicken12="$(mktemp -p /data/local/tmp)"
ButterChicken13="$ButterChicken02/keybox.xml"
ButterChicken14="$ButterChicken02/keybox.xml.bak"
ButterChicken15="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnR"
ButterChicken16="lbnQuY29tL01lb3dEdW1wL01lb3dEdW1wL3JlZ"
ButterChicken17="nMvaGVhZHMvbWFpbi9OdWxsVm9pZC9"
ButterChicken18="NZWdhdHJvbi50YXI="
ButterChicken19="$ButterChicken02/.k"
ButterChicken20="$ButterChicken02/target.txt.bak"
ButterChicken21="$ButterChicken03/download.log"
ButterChicken22="/data/adb/modules"

mkdir -p $ButterChicken03
# touch $ButterChicken03/VerifiedBootHash.txt
touch $ButterChicken03/Installation.log
# touch "/sdcard/stop"
echo " "

debug() {
    echo "$1" | tee -a "$ButterChicken04"
}

optimus() {
    echo "$1" | tee -a "$ButterChicken21"
}

megatron() {
    local _hosts="8.8.8.8 1.1.1.1 8.8.4.4"
    local _max_retries=5
    local _attempt=1

    while [ $_attempt -le $_max_retries ]; do
        for host in $_hosts; do
            if ping -c 1 -W 2 "$host" >/dev/null 2>&1 || curl -s --max-time 2 http://clients3.google.com/generate_204 >/dev/null; then
                debug " ✦ Internet connection is available"
                debug "    Attempt: ( $_attempt/$_max_retries)"
                return 0
            fi
        done

        debug "    Internet not available"
        debug "    Attempt: ( $_attempt/$_max_retries)"
        _attempt=$(( _attempt + 1 ))
        sleep 1
    done

    debug " ✦ No / Poor internet connection after $_max_retries attempts. Exiting..."
    return 1
}

soundwave() {
    pm list packages "$1" | cut -d ":" -f 2 | while read -r pkg; do
        if [ -n "$pkg" ] && ! grep -q "^$pkg" "$ButterChicken06"; then
            if [ "$teeBroken" = "true" ]; then
                echo "$pkg!" >> "$ButterChicken06"
            else
                echo "$pkg" >> "$ButterChicken06"
            fi
        fi
    done
}

unicron() {
  [ -d "$ButterChicken22/$1" ] && FOUND="$FOUND $1"
}

FOUND=""

debug " ✦ Verifying your module setup"
debug " ✦ Checking for module conflict"

debug "-------------------------------"
debug " ✦ Installed Modules List"
debug "-------------------------------"

unicron zygisk_shamiko
unicron zygisksu
unicron rezygisk
unicron zygisk_nohello
unicron neozygisk
unicron playintegrityfix
unicron susfs4ksu
unicron tricky_store

for mod in $FOUND; do
  case "$mod" in
    zygisk_shamiko) echo "• Shamiko";;
    zygisksu) echo "• ZygiskSU";;
    rezygisk) echo "• ReZygisk";;
    zygisk_nohello) echo "• Nohello";;
    neozygisk) echo "• NeoZygisk";;
    playintegrityfix) echo "• Play Integrity Fix";;
    susfs4ksu) echo "• SUSFS-FOR-KERNELSU";;
    tricky_store) echo "• Tricky Store";;
  esac
done

echo "-------------------------------"

zygisk_count=0
zygisk_modules="zygisksu rezygisk neozygisk"
for zmod in $zygisk_modules; do
  [ -d "$ButterChicken22/$zmod" ] && zygisk_count=$((zygisk_count + 1))
done

conflict_list=""
[ $zygisk_count -gt 1 ] && conflict_list="$conflict_list\n❌ Multiple Zygisk modules detected"

[ -d "$ButterChicken22/zygisk_shamiko" ] && {
  [ -d "$ButterChicken22/zygisk_nohello" ] && conflict_list="$conflict_list\n❌ Shamiko + Nohello not allowed"
#  [ -d "$ButterChicken22/susfs4ksu" ] && conflict_list="$conflict_list\n❌ Shamiko + SUSFS not allowed" #✅Works
}

[ -d "$ButterChicken22/zygisk_nohello" ] && {
  [ -d "$ButterChicken22/susfs4ksu" ] && conflict_list="$conflict_list\n❌ Nohello + SUSFS not allowed"
}

[ ! -d "$ButterChicken22/tricky_store" ] && conflict_list="$conflict_list\n❌ Tricky Store module is missing"

if [ -n "$conflict_list" ]; then
  debug "$conflict_list"
  debug " "
  debug " ✦ Suggested Setup:"
  debug "------------------------"
  debug "Choose one Zygisk base only:"
  debug "• Zygisk Next"
  debug "• ZygiskNeo"
  debug "• Rezygisk"
  debug "• Magisk's built-in zygisk"
  debug " "
  debug "Avoid using any zygisk module"
  debug "other than ZygiskNext with Shamiko"
  debug "Avoid using Nohello + SUSFS together"
  debug " "
  debug " ✦ Mandatory: Tricky Store + PlayIntegrityFix"
  debug " "
  sleep 5
else
  debug " ✦ No conflicts detected ✅"
  debug " "
fi

shockwave() {
    for path in /data/adb/modules/busybox-ndk/system/*/busybox \
                /data/adb/ksu/bin/busybox \
                /data/adb/ap/bin/busybox \
                /data/adb/magisk/busybox; do
        if [ -x "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    debug "No BusyBox executable found in candidate paths" >&2
    echo " "
    return 0
}

bumblebee() {
  _buf=0
  _bits=0
  while IFS= read -r -n1 c; do
    case "$c" in
      [A-Z]) v=$(printf '%d' "'$c"); v=$((v - 65)) ;;
      [a-z]) v=$(printf '%d' "'$c"); v=$((v - 71)) ;;
      [0-9]) v=$(printf '%d' "'$c"); v=$((v + 4)) ;;
      '+') v=62 ;;
      '/') v=63 ;;
      '=') break ;;
      *) continue ;;
    esac
    _buf=$((_buf << 6 | v))
    _bits=$((_bits + 6))
    if [ $_bits -ge 8 ]; then
      _bits=$((_bits - 8))
      out=$(( (_buf >> _bits) & 0xFF ))
      printf \\$(printf '%03o' "$out")
    fi
  done
}

TMPDIR="${TMPDIR:-/dev/tmp}"
unzip -o "$ZIPFILE" 'verify.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/verify.sh" ]; then
  debug "- Module files are corrupted, please re-download" 0.2 "sar"
  exit 1
fi

debug " "
debug " ✦ Checking Module Integrity..."
sleep 1
sh "$TMPDIR/verify.sh" || exit 1

debug " ✦ Checking for internet connection"
if ! megatron; then
    exit 1
fi

cat <<EOF > /data/adb/Box-Brain/Integrity-Box-Logs/.verify
BELIEVEinYOURdreamsANDWORKhardTOmakeTHEMreality
EOF

debug " "
debug " ✦ Scanning Play Integrity Fix"
if [ -d "$ButterChicken07" ] && [ -f "$ButterChicken08" ]; then
    if grep -q "name=Play Integrity Fix" "$ButterChicken08"; then
        debug " ✦ Detected: Play Integrity Fix module"
        debug " ✦ Refreshing fingerprint using chiteroman's fork module"
        debug " "
        sh "$ButterChicken07/autopif.sh" > /dev/null 2>&1
        debug " "
    elif grep -q "name=Play Integrity Fork" "$ButterChicken08"; then
        debug " ✦ Detected: PIF by osm0sis @ xda-developers"
        debug " ✦ Refreshing fingerprint using osm0sis's module"
        sh "$ButterChicken07/autopif2.sh" > /dev/null 2>&1
        debug " ✦ Forcing PIF to use Advanced settings"
        sh "$ButterChicken07/migrate.sh -a -f"
        debug " "
    fi
fi

 if [ -d "$ButterChicken01" ]; then
    debug " ✦ Preparing keybox downloader"

[ -s "$ButterChicken06" ] && cp -f "$ButterChicken06" "$ButterChicken20"

HIZRU=$(shockwave)
echo " ✦ Busybox set to '$HIZRU'"
echo " "
debug " ✦ Backing-up old keybox"

[ -s "$ButterChicken13" ] && cp -f "$ButterChicken13" "$ButterChicken14"

X=$(printf '%s%s%s' "$ButterChicken15" "$ButterChicken16" "$ButterChicken17" "$ButterChicken18" | tr -d '\n' | bumblebee)

PATH="${B%/*}:$PATH"
echo " ✦ Downloading keybox"

if [ -n "$HIZRU" ] && "$HIZRU" wget --help >/dev/null 2>&1; then
  "$HIZRU" wget -q --no-check-certificate -O "$ButterChicken12" "$X"
elif command -v wget >/dev/null 2>&1; then
  wget -q --no-check-certificate -O "$ButterChicken12" "$X"
elif command -v curl >/dev/null 2>&1; then
  curl -fsSL --insecure "$X" -o "$ButterChicken12"
else
  optimus " ✦ No supported downloader found (BusyBox/wget/curl)" >&2
  rm -f "$ButterChicken12"
  exit 7
fi

[ -s "$ButterChicken12" ] || { rm -f "$ButterChicken12"; exit 3; }

tmp="$ButterChicken12"
for i in $(seq 1 10); do
  next="$(mktemp -p /data/local/tmp)"
  if ! base64 -d "$tmp" > "$next" 2>/dev/null; then
    optimus " ✦ Decoding failed at round $i"
    rm -f "$ButterChicken12" "$tmp" "$next"
    exit 4
  fi
  [ "$tmp" != "$ButterChicken12" ] && rm -f "$tmp"
  tmp="$next"
done

hex_decoded="$(mktemp -p /data/local/tmp)"
if ! xxd -r -p "$tmp" > "$hex_decoded" 2>/dev/null; then
  optimus " ✦ HEX decoding failed"
  rm -f "$tmp" "$hex_decoded" "$ButterChicken12"
  exit 5
fi
rm -f "$tmp"

if ! tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$hex_decoded" > "$ButterChicken19"; then
  optimus " ✦ ROT13 decoding failed"
  rm -f "$hex_decoded" "$ButterChicken12"
  exit 6
fi
rm -f "$hex_decoded"

[ -s "$ButterChicken19" ] && cp -f "$ButterChicken19" "$ButterChicken13"

rm -f "$ButterChicken12" "$ButterChicken19"
F="helloButterChicken"

if [ ! -s "$ButterChicken13" ]; then
  if [ -s "$ButterChicken14" ]; then
    mv -f "$ButterChicken14" "$ButterChicken13"
    optimus " ✦ Update failed, Restoring backup"
  else
    optimus " ✦ Update failed. No backup available"
  fi
  exit 5
else
  optimus " ✦ Keybox downloaded successfully"
fi

[ -s "$ButterChicken13" ] || {
    optimus "  ❌ File not found or empty: $ButterChicken13"
    exit 1
}

echo " "
optimus " ✦ Verifying keybox.xml"

integrity_expr=""
for w in $F; do
    integrity_expr="${integrity_expr}s/${w}//g;"
done

integrity_tmp="${ButterChicken13}.cleaned"
sed "$integrity_expr" "$ButterChicken13" > "$integrity_tmp" && mv -f "$integrity_tmp" "$ButterChicken13"

optimus " ✦ Verification succeed"

   teeBroken="false"
   if [ -f "$ButterChicken11" ]; then
     teeBroken=$( { grep -E '^teeBroken=' "$ButterChicken11" | cut -d '=' -f2; } 2>/dev/null || echo "false" )
   fi

   echo " "
   debug " ✦ Updating target list as per your TEE status"

   {
     echo "# Last updated on $(date '+%A %d/%m/%Y %I:%M:%S%p')"
     echo "#"
     echo "android"
     echo "com.android.vending!"
     echo "com.google.android.gms!"
     echo "com.google.android.contactkeys!"
     echo "com.google.android.gsf!"
     echo "com.google.android.ims!"
     echo "com.google.android.safetycore!"
     echo "com.reveny.nativecheck!"
     echo "io.github.vvb2060.keyattestation!"
     echo "io.github.qwq233.keyattestation!"
     echo "io.github.vvb2060.mahoshojo"
     echo "icu.nullptr.nativetest"
   } > "$ButterChicken06"

     soundwave "-3"
     soundwave "-s"
   debug " ✦ Target list has been updated "

   if [ ! -f "$ButterChicken10" ]; then
     echo "all=$ButterChicken09" > "$ButterChicken10"
   fi

   debug " ✦ TrickyStore spoof applied "
   chmod 644 "$ButterChicken06"
   debug " "
   sleep 1
 else
   debug " ✦ Skipping TS related functions"
   debug "  TrickyStore is not installed"
 fi

if [ -f /data/adb/magisk/magisk ]; then
  rm -f $ButterChicken05/debug
fi

chmod +x "$ButterChicken05/cleanup.sh"
sh "$ButterChicken05/cleanup.sh"
sleep 2

debug " "
debug " "
debug "         ••• Installation Completed ••• "
debug " "
debug " " 

nohup am start -a android.intent.action.VIEW -d https://t.me/MeowRedirect/771 >/dev/null 2>&1 &
debug "This module was released by 𝗠𝗘𝗢𝗪 𝗗𝗨𝗠𝗣"
exit 0
# End Of File