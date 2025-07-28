#!/system/bin/sh

SCRIPT_DIR="/data/adb/modules/integrity_box/webroot/common_scripts"
KEY_DIR="/data/adb/modules/integrity_box"
TMP_KEY="/dev/key_tmp"

MENU="
Update Keybox:key.sh
Kill GMS process:kill.sh
Set Custom Fingerprint:pif.sh
Spoof PIF SDK:spoof.sh
Add All apps in Target list:systemuser.sh
Disable Auto-Whitelist Mode:stop.sh
Enable Auto-Whitelist Mode:start.sh
Add only User apps in Target list:user.sh
Spoof/Unspoof Security Patch:patch.sh
Enable/Disable WebUI timeout:modal.sh
Set AOSP keybox:aosp.sh
Set Valid keybox (if AOSP):keybox.sh
FIX Device not Certified:vending.sh
Update SusFS Config:sus.sh
Enable GMS Spoofing prop:setprop.sh
Disable GMS Spoofing prop:resetprop.sh
Abnormal Detection:abnormal.sh
Flagged Apps Detection:app.sh
Props Detection:prop.sh
Help Group:meowverse.sh
Telegram Channel:meowdump.sh
Report a problem:issue.sh
Change SElinux status:selinux.sh
"

popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity > /dev/null
    sleep 0.5
}

draw_box() {
  echo " "
  echo "╔══════════════════════════╗"
  while IFS= read -r line; do
    printf "║ %-28s ║\n" "$line"
  done <<EOF
$1
EOF
  echo "╚══════════════════════════╝"
  echo " "
}

print_menu() {
  clear
  draw_box "     Integrity-Box Menu "
  echo " ✦ Use Volume Down to navigate"
  echo " ✦ Use Volume Up to execute"
  echo " "
  print_selection_only
}

print_selection_only() {
  i=1
  while IFS= read -r line; do
    LABEL=$(echo "$line" | cut -d: -f1)
    [ "$i" -eq "$INDEX" ] && echo ">> $LABEL" || echo "   $LABEL"
    i=$((i + 1))
  done < /dev/tmp_menu
  echo " "
}

# Function to get key press using keycheck
wait_for_key() {
  chmod +x "$KEY_DIR/keycheck"

  while :; do
    "$KEY_DIR/keycheck"
    KEY="$?"

    # Debounce loop: wait until no key is pressed
    sleep 0.2
    "$KEY_DIR/keycheck"
    [ "$?" != "$KEY" ] && continue

    # Once key is stable, return the value
    return "$KEY"
  done
}

# Setup Menu
echo "$MENU" | sed '/^$/d' > /dev/tmp_menu
TOTAL=$(wc -l < /dev/tmp_menu)
INDEX=1

print_menu

# Main Interaction Loop
while :; do
  wait_for_key
  key=$?

  case "$key" in
    42) # Volume Up
      SELECTED=$(sed -n "${INDEX}p" /dev/tmp_menu)
      LABEL=$(echo "$SELECTED" | cut -d: -f1)
      SCRIPT=$(echo "$SELECTED" | cut -d: -f2)
      sh "$SCRIPT_DIR/$SCRIPT"
      echo " ✦ Done."
      break
      ;;
    41) # Volume Down
      INDEX=$((INDEX + 1))
      [ "$INDEX" -gt "$TOTAL" ] && INDEX=1
      SELECTED=$(sed -n "${INDEX}p" /dev/tmp_menu)
      LABEL=$(echo "$SELECTED" | cut -d: -f1)
      clear
      draw_box "     Integrity-Box Menu "
      echo " ✦ Use Volume Down to navigate"
      echo " ✦ Use Volume Up to execute"
      echo " "
      print_selection_only
      ;;
  esac
done

rm -f /dev/tmp_menu
exit 0
