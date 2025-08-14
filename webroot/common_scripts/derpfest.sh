#!/system/bin/sh

# Target prop
PROP_NAME="persist.sys.pixelprops.integrity"

# Get current value
CURRENT_VALUE=$(su -c getprop "$PROP_NAME")

# Check if prop exists
if [ -z "$CURRENT_VALUE" ]; then
    echo "You're not on Deepest ROM"
    exit 1
fi

# Toggle value
if [ "$CURRENT_VALUE" = "true" ]; then
    su -c resetprop -n -p "$PROP_NAME" false
    echo "Disabled inbuilt spoofing"
else
    su -c resetprop -n -p "$PROP_NAME" true
    echo "Enabled inbuilt spoofing"
fi