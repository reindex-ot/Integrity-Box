#!/system/bin/sh
# Only set the properties if they already exist
if getprop persist.sys.pihooks.disable.gms_props >/dev/null 2>&1; then
    su -c setprop persist.sys.pihooks.disable.gms_props true
fi

if getprop persist.sys.pihooks.disable.gms_key_attestation_block >/dev/null 2>&1; then
    su -c setprop persist.sys.pihooks.disable.gms_key_attestation_block true
fi

# Delete related props safely
su -c 'getprop | grep -Ei "pihook|pixelprops|gms|pi" | sed -E "s/^\[(.*)\]:.*/\1/" | while read -r prop; do
    resetprop -p -d "$prop"
done'

echo "Done, Reopen detector to check"