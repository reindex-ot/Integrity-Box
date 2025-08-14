#!/system/bin/sh
resetprop -p -d persist.sys.pihooks.disable.gms_props
resetprop -p -d persist.sys.pihooks.disable.gms_key_attestation_block
echo "Switched back to default settings"
exit 0