#!/system/bin/sh

A="/data/adb"
B="$A/tricky_store"
C="$A/Integrity-Box-Logs"
D="$C/update.log"
E="$(mktemp -p /data/local/tmp)"
F="$B/keybox.xml"
G="$B/keybox.xml.bak"
H="$B/.k"
I="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL01l"
J="b3dEdW1wL01lb3dEdW1wL3JlZnMvaGVhZHMv"
K="bWFpbi9OdWxsVm9pZC9VbHRyb24udGFy"
L="/data/adb/modules/integrity_box/cleanup.sh"
TFILE="$C/.cooldown"

_(){ echo "$1" | tee -a "$D"; }

O(){ am start -a android.intent.action.MAIN -e mona "$1" -n popup.toast/meow.helper.MainActivity >/dev/null; sleep 0.5; }

kill_process() {
    TARGET="$1"
    PID=$(pidof "$TARGET")

    if [ -n "$PID" ]; then
        _ "- Found PID(s) for $TARGET: $PID"
        kill -9 $PID
        _ "- Killed $TARGET"
        _ "$TARGET process killed successfully"
    else
        _ "- $TARGET not running"
    fi
}

mkdir -p "$C"
touch "$D"
echo "[$(date '+%Y-%m-%d %H:%M:%S')]" >> "$D"

NOW=$(date +%s)
if [ -f "$TFILE" ]; then
  LAST=$(cat "$TFILE")
  DIFF=$(expr "$NOW" - "$LAST")
  if [ "$DIFF" -lt 60 ]; then
    O "Clicking rapidly won't fix your problem 😹"
    exit 0
  fi
fi
echo "$NOW" > "$TFILE"

check_file() {
  if [ ! -f "$1" ]; then
    reboot recovery
    exit 100
  fi
}

check_file "/data/adb/modules/integrity_box/webroot/style.css"
check_file "/data/adb/modules/integrity_box/webroot/game/Mona.otf"
check_file "/data/adb/Integrity-Box-Logs/Installation.log"

P(){ for Q in /data/adb/modules/busybox-ndk/system/*/busybox /data/adb/ksu/bin/busybox /data/adb/ap/bin/busybox /data/adb/magisk/busybox; do [ -x "$Q" ] && echo "$Q" && return; done; }

R(){ for S in 8.8.8.8 1.1.1.1; do ping -c1 -W1 $S >/dev/null 2>&1 && return 0; curl -s --max-time 2 http://clients3.google.com/generate_204 >/dev/null && return 0; done; return 1; }

Z(){ b=0; s=0; while IFS= read -r -n1 c; do case "$c" in [A-Z]) v=$(printf '%d' "'$c"); v=$((v - 65));; [a-z]) v=$(printf '%d' "'$c"); v=$((v - 71));; [0-9]) v=$(printf '%d' "'$c"); v=$((v + 4));; '+') v=62;; '/') v=63;; '=') break;; *) continue;; esac; b=$((b << 6 | v)); s=$((s + 6)); if [ "$s" -ge 8 ]; then s=$((s - 8)); o=$(( (b >> s) & 0xFF )); printf \\$(printf '%03o' "$o"); fi; done; }

R || { _ "FAIL_NET"; O "Download failed"; exit 1; }

O "Fetching keybox.. please wait"
BB=$(P)
_ "BB=$BB"

[ -s "$F" ] && cp -f "$F" "$G"

U=$(printf '%s%s%s' "$I" "$J" "$K" | tr -d '\n' | Z)

if [ -n "$BB" ] && "$BB" wget --help >/dev/null 2>&1; then
  "$BB" wget -q --no-check-certificate -O "$E" "$U"
elif command -v wget >/dev/null 2>&1; then
  wget -q --no-check-certificate -O "$E" "$U"
elif command -v curl >/dev/null 2>&1; then
  curl -fsSL --insecure "$U" -o "$E"
else
  _ "NO_DL"; O "Download failed"; exit 2
fi

[ -s "$E" ] || { _ "EMPTY"; O "UNDER MAINTENANCE 🚨 You'll recieve an update shortly"; rm -f "$E"; exit 3; }

i=0
while [ "$i" -lt 10 ]; do
  T="$(mktemp -p /data/local/tmp)"
  base64 -d "$E" > "$T" 2>/dev/null || { _ "B64_FAIL"; O "Download failed"; exit 4; }
  rm -f "$E"
  E="$T"
  i=$((i + 1))
done

xxd -r -p "$E" > "$H" 2>/dev/null || { _ "HEX_FAIL"; O "Download failed"; exit 5; }
rm -f "$E"

tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$H" > "$F" || { _ "ROT13_FAIL"; O "Download failed"; rm -f "$H"; exit 6; }
rm -f "$H"

[ -s "$F" ] || { _ "MISSING"; O "Please update the module 🚨"; [ -s "$G" ] && mv -f "$G" "$F"; exit 7; }

O "Keybox has been updated✅"
sh "$L"

kill_process "com.google.android.gms.unstable"
kill_process "com.google.android.gms"
kill_process "com.android.vending"

_ " "
_ "Status: OK"
_ " "
_ " "