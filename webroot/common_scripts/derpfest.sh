#!/system/bin/sh

# Target prop
PROP_NAME="persist.sys.pixelprops.integrity"

# Popup function
popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n imagine.detecting.ablank.app/mona.meow.MainActivity > /dev/null
    sleep 0.5
}

# Get current value
CURRENT_VALUE=$(su -c getprop "$PROP_NAME")

# Check if prop exists
if [ -z "$CURRENT_VALUE" ]; then
    popup "You're not on Deepest ROM"
    exit 1
fi

# Toggle value
if [ "$CURRENT_VALUE" = "true" ]; then
    su -c resetprop -n -p "$PROP_NAME" false
    popup "Disabled inbuilt spoofing"
else
    su -c resetprop -n -p "$PROP_NAME" true
    popup "Enabled inbuilt spoofing"
fi