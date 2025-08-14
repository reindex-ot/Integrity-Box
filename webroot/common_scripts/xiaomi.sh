#!/system/bin/sh

# App package to toggle
PACKAGE_NAME="eu.xiaomi.module.inject"

# Check if the package exists
if ! su -c pm list packages | grep -q "$PACKAGE_NAME"; then
    echo "You're not using EU ROM"
    exit 1
fi

# Check current enabled/disabled state
APP_STATE=$(su -c dumpsys package "$PACKAGE_NAME" | grep -i "enabled=" | head -n 1 | awk -F= '{print $2}')

if [ "$APP_STATE" = "true" ] || [ "$APP_STATE" = "1" ]; then
    echo "Disabling: $PACKAGE_NAME"
    su -c pm disable "$PACKAGE_NAME" &>/dev/null
else
    echo "Enabling: $PACKAGE_NAME"
    su -c pm enable "$PACKAGE_NAME" &>/dev/null
fi