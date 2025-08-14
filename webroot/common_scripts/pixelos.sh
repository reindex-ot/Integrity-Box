#!/system/bin/sh

# Function to set resetprop
set_resetprop() {
    PROP="$1"
    VALUE="$2"
    CURRENT=$(su -c getprop "$PROP")
    if [ -z "$CURRENT" ]; then
        log "You're not using PixelOS"
    else
        su -c resetprop -n -p "$PROP" "$VALUE"
        log "$PROP → $VALUE"
    fi
}

# Function to setprop
set_simpleprop() {
    PROP="$1"
    VALUE="$2"
    CURRENT=$(su -c getprop "$PROP")
    if [ -z "$CURRENT" ]; then
        log "You're not using PixelOS"
    else
        su -c setprop "$PROP" "$VALUE"
        log "$PROP → $VALUE"
    fi
}

# Resetprop props
set_resetprop persist.sys.pihooks.disable.gms_key_attestation_block true
set_resetprop persist.sys.pihooks.disable.gms_props true

# setprop props
set_simpleprop persist.sys.pihooks.disable 1
set_simpleprop persist.sys.kihooks.disable 1

# Restart Zygote
# su -c setprop ctl.restart zygote
# log "Zygote restarted"