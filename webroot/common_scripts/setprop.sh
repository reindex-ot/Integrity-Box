popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n imagine.detecting.ablank.app/mona.meow.MainActivity > /dev/null
    sleep 0.5
}

resetprop -p -d persist.sys.pihooks.disable.gms_props
resetprop -p -d persist.sys.pihooks.disable.gms_key_attestation_block

popup "Switched back to default settings"