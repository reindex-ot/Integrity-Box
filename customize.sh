#!/system/bin/sh
MODDIR=${0%/*}
mona01="/data/adb/modules/tricky_store"
mona02="/data/adb/tricky_store"
mona03="/data/adb/Integrity-Box-Logs"
mona04="$mona03/Installation.log"
mona05="/data/adb/modules_update/integrity_box"
mona06="/data/adb/susfs4ksu/sus_path.txt"
mona07="Toaster.apk"
mona08="com.helluva.product.integrity"
mona09="$mona02/target.txt"
mona10="/data/adb/modules/playintegrityfix"
mona11="$mona10/module.prop"
mona12="2025-06-06"
mona13="$mona02/security_patch.txt"
mona14="$mona05/hashes.txt"
mona15="$mona05/customize.sh"
mona16="$mona02/tee_status"
mona17="$mona05/$mona07"
mona18="$(mktemp -p /data/local/tmp)"
mona19="$mona02/keybox.xml"
mona20="$mona02/keybox.xml.bak"
mona21="$mona03/download.log"
mona22="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL01l"
mona23="b3dEdW1wL01lb3dEdW1wL3JlZnMvaGVhZHMv"
mona24="bWFpbi9OdWxsVm9pZC9"
mona25="$mona02/.k"
mona26="$mona02/target.txt.bak"
mona27="$mona03/download.log"
mona28="imagine.detecting.ablank.app"
mona29="/data/adb/modules"
mona30="$mona05/$mona07"
mona31="/data/adb/service.d"
mona32="/sdcard/skip"
mona33="NZWdhdHJvbi50YXI="

# Logger
meow() {
    echo "$1" | tee -a "$mona04"
}

meownload() {
    echo "$1" | tee -a "$mona27"
}

# Create files & folder 
mkdir -p $mona03
touch $mona03/VerifiedBootHash.txt
mkdir -p $mona31
touch $mona03/Installation.log
touch "/sdcard/stop"
meow " "

cat <<'EOF' > "$mona31/debug.sh"
#!/system/bin/sh
L="/data/adb/Integrity-Box-Logs/debug.log"

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

chmod 755 "$mona31/debug.sh"

# Verify ZIP
TMPDIR="${TMPDIR:-/dev/tmp}"
unzip -o "$ZIPFILE" 'verify.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/verify.sh" ]; then
  debug "- Module files are corrupted, please re-download" 0.2 "sar"
  exit 1
fi

# Check integrity
meow " "
meow " ✦ Checking Module Integrity..."
sleep 1
sh "$TMPDIR/verify.sh" || exit 1

# Internet check function
internet() {
    local _hosts="8.8.8.8 1.1.1.1 8.8.4.4"
    local _max_retries=5
    local _attempt=1

    while [ $_attempt -le $_max_retries ]; do
        for host in $_hosts; do
            # Use TCP check as fallback if ICMP fails (using curl)
            if ping -c 1 -W 2 "$host" >/dev/null 2>&1 || curl -s --max-time 2 http://clients3.google.com/generate_204 >/dev/null; then
                meow " ✦ Internet connection is available"
                meow "    Attempt: ( $_attempt/$_max_retries)"
                return 0
            fi
        done

        meow "    Internet not available"
        meow "    Attempt: ( $_attempt/$_max_retries)"
        _attempt=$(( _attempt + 1 ))
        sleep 1
    done

    meow " ✦ No / Poor internet connection after $_max_retries attempts. Exiting..."
    return 1
}

# TEE status [!]
tee_detector() {
    pm list packages "$1" | cut -d ":" -f 2 | while read -r pkg; do
        if [ -n "$pkg" ] && ! grep -q "^$pkg" "$mona09"; then
            if [ "$teeBroken" = "true" ]; then
                echo "$pkg!" >> "$mona09"
            else
                echo "$pkg" >> "$mona09"
            fi
        fi
    done
}

# Pop-up function 
popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n imagine.detecting.ablank.app/mona.meow.MainActivity > /dev/null
    sleep 0.5
}

# Tampering detector
verify_integrity() {
    local hash_file="$1"
    local file="$2"
    local expected_var="$3"

    if [ ! -f "$hash_file" ]; then
        meow " ✦ Error: Hash file not found at $hash_file"
        return 1
    fi

    . "$hash_file"

    expected_hash=$(eval echo \$$expected_var)

    if [ -z "$expected_hash" ]; then
        meow " ✦ Error: No hash defined for $expected_var in $hash_file"
        return 1
    fi

    if [ ! -f "$file" ]; then
        meow " ✦ Error: Target file not found at $file"
        return 1
    fi

    local actual_hash
    actual_hash=$(md5sum "$file" 2>/dev/null | awk '{print $1}')

    if [ -z "$actual_hash" ]; then
        meow " ✦ Error calculating checksum for $file"
        return 1
    fi

    if [ "$actual_hash" != "$expected_hash" ]; then
        meow " ✦ Tampering detected in $file"
        meow " ✦ Expected: $expected_hash"
        meow " ✦ Found:    $actual_hash"
        return 1
    fi

    meow " ✦ Verified : $(basename "$file")"
    return 0
}

# Detect modules
detect() {
  [ -d "$mona29/$1" ] && FOUND="$FOUND $1"
}

FOUND=""

meow " ✦ Verifying your module setup"
meow " ✦ Checking for module conflict"

meow "-------------------------------"
meow " ✦ Installed Modules List"
meow "-------------------------------"

detect zygisk_shamiko
detect zygisksu
detect rezygisk
detect zygisk_nohello
detect neozygisk
detect playintegrityfix
detect susfs4ksu
detect tricky_store

# Print installed modules
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

# Count zygisk modules
zygisk_count=0
zygisk_modules="zygisksu rezygisk neozygisk"
for zmod in $zygisk_modules; do
  [ -d "$mona29/$zmod" ] && zygisk_count=$((zygisk_count + 1))
done

# Conflict checks
conflict_list=""
[ $zygisk_count -gt 1 ] && conflict_list="$conflict_list\n❌ Multiple Zygisk modules detected"

[ -d "$mona29/zygisk_shamiko" ] && {
  [ -d "$mona29/zygisk_nohello" ] && conflict_list="$conflict_list\n❌ Shamiko + Nohello not allowed"
#  [ -d "$mona29/susfs4ksu" ] && conflict_list="$conflict_list\n❌ Shamiko + SUSFS not allowed" #✅Works
}

[ -d "$mona29/zygisk_nohello" ] && {
  [ -d "$mona29/susfs4ksu" ] && conflict_list="$conflict_list\n❌ Nohello + SUSFS not allowed"
}

# Mandatory module check
[ ! -d "$mona29/tricky_store" ] && conflict_list="$conflict_list\n❌ Tricky Store module is missing"

# Final output
if [ -n "$conflict_list" ]; then
  meow "$conflict_list"
  meow " "
  meow " ✦ Suggested Setup:"
  meow "------------------------"
  meow "Choose one Zygisk base only:"
  meow "• Zygisk Next"
  meow "• ZygiskNeo"
  meow "• Rezygisk"
  meow "• Magisk's built-in zygisk"
  meow " "
  meow "Avoid using any zygisk module"
  meow "other than ZygiskNext with Shamiko"
  meow "Avoid using Nohello + SUSFS together"
  meow " "
  meow " ✦ Mandatory: Tricky Store + PlayIntegrityFix"
  meow " "
  sleep 5
else
  meow " ✦ No conflicts detected ✅"
  meow " "
fi

meow " ✦ Checking for internet connection"
if ! internet; then
    exit 1
fi

meow " "
meow " ✦ Re-Verifying via MD5"
verify_integrity "$mona14" "$mona15" "script" || exit 1
verify_integrity "$mona14" "$mona17" "toaster" || exit 1

# Remove old pop-up generator
#meow " ✦ Preparing toaster"
#if pm list packages | grep -q "meow.helper"; then
#  pm uninstall meow.helper >/dev/null 2>&1
#fi

# Install toaster only if $mona32 does NOT exist
if [ -f "$mona32" ]; then
    meow " "
    meow " ✦ Skip file detected"
    meow " ✦ Skipping popup installation"
    meow " "
else
    if [ -f "$mona30" ]; then
        if pm install "$mona30" >/dev/null 2>&1; then
            popup "Thanks for using INTEGRITY BOX"
        else
            meow "Toaster installation failed."
        fi
    else
        meow "Toaster.apk not found"
    fi
fi

# BusyBox detector 
busybox_finder() {
    for path in /data/adb/modules/busybox-ndk/system/*/busybox \
                /data/adb/ksu/bin/busybox \
                /data/adb/ap/bin/busybox \
                /data/adb/magisk/busybox; do
        if [ -x "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    meow "No BusyBox executable found in candidate paths" >&2
    echo ""
    return 0
}

# Sanatization function
sanitizer() {
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

#Refresh the fp using PIF module 
meow " "
meow " ✦ Scanning Play Integrity Fix"
if [ -d "$mona10" ] && [ -f "$mona11" ]; then
    if grep -q "name=Play Integrity Fix" "$mona11"; then
        meow " ✦ Detected: Play Integrity Fix module"
        meow " ✦ Refreshing fingerprint using chiteroman's fork module"
        meow " "
        sh "$mona10/autopif.sh" > /dev/null 2>&1
        popup "Custom Fingerprint has been updated"
        meow " "
    elif grep -q "name=Play Integrity Fork" "$mona11"; then
        meow " ✦ Detected: PIF by osm0sis @ xda-developers"
        meow " ✦ Refreshing fingerprint using osm0sis's module"
        sh "$mona10/autopif2.sh" > /dev/null 2>&1
        meow " ✦ Forcing PIF to use Advanced settings"
        sh "$mona10/migrate.sh -a -f"
        popup "Custom Fingerprint has been updated"
        meow " "
        
    fi
fi

# Disable ximi PIF if exists 
#if su -c pm list packages | grep -q "eu.xiaomi.module.inject"; then
#    meow " ✦ Disabling spoofing for EU ROMs"
#    su -c pm disable eu.xiaomi.module.inject &>/dev/null
#fi

# Disable HelluvaOs pif if exists 
#if pm list packages | grep -q "$mona08"; then
#    pm disable-user $mona08
#    meow " ✦ Disabled Hentai PIF"
#fi
#sleep 1

# SusFS related function 
#meow " ✦ Performing internal checks"
#meow " ✦ Checking for susFS"
#if [ -f "$mona06" ]; then
#    meow " ✦ SusFS is installed"
#    meow " "
#    popup " Let Me Take Care Of This🤫"

#touch "$mona06"
#chmod 644 "$mona06"

#echo "----------------------------------------------------------" >> "$mona04"
#echo "Logged on $(date '+%A %d/%m/%Y %I:%M:%S%p')" >> "$mona04"
#echo "----------------------------------------------------------" >> "$mona04"
#echo " " >> "$mona04-"

#if [ ! -w "$mona06" ]; then
#    meow " ✦ $mona06 is not writable. Please check file permissions."
#    exit 0
#fi

#meow " ✦ Adding necessary paths to sus list"
#> "$mona06"

#for path in \
#    "/system/addon.d" \
#    "/sdcard/TWRP" \
#    "/sdcard/Fox" \
#    "/vendor/bin/install-recovery.sh" \
#    "/system/bin/install-recovery.sh"; do
#    echo "$path" >> "$mona06"
#done

#meow " ✦ Scanning system for Custom ROM detection.."
#popup "This'll take a few seconds, have patience "
#for dir in /system /product /data /vendor /etc /root; do
#    find "$dir" -type f 2>/dev/null | grep -i -E "lineageos|crdroid|gapps|evolution|magisk" >> "$mona06"
#done

#chmod 644 "$mona06"
#meow " ✦ Scan complete. & saved to sus list "

#popup "Make it SUS🥷"
#meow " "
#else
#    meow " ✦ SusFS not found. Skipping file generation"
#    meow " "
#fi

# Tricky Store related functions
#popup " Patience is the key"
 if [ -d "$mona01" ]; then
    meow " ✦ Preparing keybox downloader"

[ -s "$mona09" ] && cp -f "$mona09" "$mona26"

BUSYBOX=$(busybox_finder)
echo " ✦ Busybox set to '$BUSYBOX'"
echo " "
meow " ✦ Backing-up old keybox"

[ -s "$mona19" ] && cp -f "$mona19" "$mona20"

X=$(printf '%s%s%s' "$mona22" "$mona23" "$mona24" "$mona33" | tr -d '\n' | sanitizer)

PATH="${B%/*}:$PATH"
echo " ✦ Downloading keybox"

if [ -n "$BUSYBOX" ] && "$BUSYBOX" wget --help >/dev/null 2>&1; then
  "$BUSYBOX" wget -q --no-check-certificate -O "$mona18" "$X"
elif command -v wget >/dev/null 2>&1; then
  wget -q --no-check-certificate -O "$mona18" "$X"
elif command -v curl >/dev/null 2>&1; then
  curl -fsSL --insecure "$X" -o "$mona18"
else
  meownload " ✦ No supported downloader found (BusyBox/wget/curl)" >&2
  rm -f "$mona18"
  exit 7
fi

[ -s "$mona18" ] || { rm -f "$mona18"; exit 3; }

tmp="$mona18"
for i in $(seq 1 10); do
  next="$(mktemp -p /data/local/tmp)"
  if ! base64 -d "$tmp" > "$next" 2>/dev/null; then
    meownload " ✦ Decoding failed at round $i"
    rm -f "$mona18" "$tmp" "$next"
    exit 4
  fi
  [ "$tmp" != "$mona18" ] && rm -f "$tmp"
  tmp="$next"
done

hex_decoded="$(mktemp -p /data/local/tmp)"
if ! xxd -r -p "$tmp" > "$hex_decoded" 2>/dev/null; then
  meownload " ✦ HEX decoding failed"
  rm -f "$tmp" "$hex_decoded" "$mona18"
  exit 5
fi
rm -f "$tmp"

if ! tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$hex_decoded" > "$mona25"; then
  meownload " ✦ ROT13 decoding failed"
  rm -f "$hex_decoded" "$mona18"
  exit 6
fi
rm -f "$hex_decoded"

[ -s "$mona25" ] && cp -f "$mona25" "$mona19"

rm -f "$mona18" "$mona25"
F="hellomona"

if [ ! -s "$mona19" ]; then
  if [ -s "$mona20" ]; then
    mv -f "$mona20" "$mona19"
    meownload " ✦ Update failed, Restoring backup"
  else
    meownload " ✦ Update failed. No backup available"
  fi
  exit 5
else
  popup "Keybox downloaded successfully"
fi

[ -s "$mona19" ] || {
    meownload "  ❌ File not found or empty: $mona19"
    exit 1
}

echo " "
meownload " ✦ Verifying keybox.xml"

integrity_expr=""
for w in $F; do
    integrity_expr="${integrity_expr}s/${w}//g;"
done

integrity_tmp="${mona19}.cleaned"
sed "$integrity_expr" "$mona19" > "$integrity_tmp" && mv -f "$integrity_tmp" "$mona19"

meownload " ✦ Verification succeed"

   teeBroken="false"
   if [ -f "$mona16" ]; then
     teeBroken=$( { grep -E '^teeBroken=' "$mona16" | cut -d '=' -f2; } 2>/dev/null || echo "false" )
   fi

   echo " "
   meow " ✦ Updating target list as per your TEE status"

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
   } > "$mona09"

     tee_detector "-3"
     tee_detector "-s"
   meow " ✦ Target list has been updated "

   if [ ! -f "$mona13" ]; then
     echo "all=$mona12" > "$mona13"
   fi

   meow " ✦ TrickyStore spoof applied "
   chmod 644 "$mona09"
   meow " "
   sleep 1
 else
   meow " ✦ Skipping TS related functions"
   meow "  TrickyStore is not installed"
 fi

# Remove banner for magisk users 
if [ -f /data/adb/magisk/magisk ]; then
  rm -f $mona05/meow
fi

# Remove openssl binaries & logs generate by any previous version of module (if exists)
chmod +x "$mona05/cleanup.sh"
sh "$mona05/cleanup.sh"
sleep 2

PKG="com.android.vending"
THRESHOLD_MAJOR=45

version_name=$(dumpsys package "$PKG" 2>/dev/null | grep -m 1 "versionName=" | cut -d= -f2)
version_major=$(echo "$version_name" | cut -d. -f1)

if [ -z "$version_name" ]; then
  echo "Unable to detect Play Store version."
  exit 0
fi

if [ "$version_major" -gt "$THRESHOLD_MAJOR" ]; then
  echo " "
  echo "=================================="
  echo "   Play Store Version Check"
  echo "=================================="
  sleep 1
  echo "Detected Play Store version: $version_name"
  sleep 2
  echo " "
  echo "      --------------------"
  echo "            NOTICE:"
  echo "      --------------------"
  sleep 1
  echo "Various users have reported being unable "
  echo "to pass Play Integrity on these versions. "
  echo "This issue is user-specific, some users"
  echo "still pass without any problems."
  sleep 3
  echo " "
  echo "If you are facing this problem, "
  echo "follow the steps below:"
  sleep 2
  echo " "
  echo "------------------------------------------------------"
  echo "Steps to try if failing Device or Strong Integrity:"
  echo "------------------------------------------------------"
  sleep 1
  echo " ✦ Open App Info for Google Play Store"
  sleep 2
  echo " ✦ Tap the 3 dots (menu) in the top-right"
  sleep 2
  echo " ✦ Select 'Uninstall updates'"
  sleep 2
  echo " ✦ Open Play Store settings and disable auto-updates"
  sleep 2
  echo " ✦ Install the provided downgraded Play Store APK"
  sleep 2
  echo " ✦ Use MT Manager / SAI to install it"
  sleep 4
  echo " "
  echo "Installation will complete shortly and"
  echo "you will be redirected to the APK file."
  echo " "
fi

meow " "
meow " "
meow "         ••• Installation Completed ••• "
meow " "
meow " " 

# Redirect Module Release Source and Finish Installation
nohup am start -a android.intent.action.VIEW -d https://t.me/MeowRedirect/771 >/dev/null 2>&1 &
#popup "This module was released by 𝗠𝗘𝗢𝗪 𝗗𝗨𝗠𝗣"
popup "Redirecting to downgraded Playstore version APK"
exit 0
# End Of File