#!/system/bin/sh
echo "     ____      __                  _ __       "
echo "    /  _/___  / /____  ____ ______(_) /___  __"
echo "    / // __ \/ __/ _ \/ __ / ___/ / __/ / /  / "
echo "  _/ // / / / /_/  __/ /_/ / /  / / /_/ /_/ / "
echo " /___/_/_/_/\__/\___/\__, /_/  /_/\__/\__, /  "
echo "      ___           ____/            ____/   "
echo "    / __ )____  _     "
echo "   / __  / __ \| |/_/ "
echo "  / /_/ / /_/ />  < "
echo " /_____/\____/_/|_| "
echo " "
echo " "

echo "Initializing Auto Mode. Please wait..."
echo " "

SCRIPT_DIR="/data/adb/modules/integrity_box/webroot/common_scripts"
PIF="/data/adb/modules/playintegrityfix"
TARGET="/data/adb/modules/integrity_box/boot-completed.sh"
KILL="$SCRIPT_DIR/kill.sh"
UPDATE="$SCRIPT_DIR/key.sh"
LOG="/data/adb/Box-Brain/Integrity-Box-Logs/action.log"

TOTAL_STEPS=5
PASS_COUNT=0
FAIL_COUNT=0
SUMMARY=""

# logger
log_line() {
    printf "%s\n" "$1" | tee -a "$LOG"
}

# print step header
start_step() {
    log_line ""
    log_line "----------------------------------------"
    log_line "[$1/${TOTAL_STEPS}] $2"
    log_line "----------------------------------------"
}

# run a command (passed as single string), capture output and exit code
run_cmd_capture() {
    CMD_STR="$1"
    TMP_OUT="/data/local/tmp/integrity_box_action.$$"
    # run the command, capture stdout+stderr to TMP_OUT
    sh -c "$CMD_STR" >"$TMP_OUT" 2>&1
    RC=$?
    # stream output lines to log
    if [ -f "$TMP_OUT" ]; then
        while IFS= read -r line; do
            [ -n "$line" ] && log_line "    → $line"
        done < "$TMP_OUT"
        rm -f "$TMP_OUT"
    fi
    return $RC
}

# safe delay handler
handle_delay() {
    if [ -z "$MMRL" ]; then
        if [ "$KSU" = "true" ] || [ "$APATCH" = "true" ]; then
            if [ "$KSU_NEXT" != "true" ]; then
                log_line "Closing dialog in 10 seconds..."
                sleep 5
            fi
        fi
    fi
}

# Step 1
start_step 1 "Updating Tricky Store packages"
#log_line "  - Updating target list as per your TEE status"
if run_cmd_capture "sh \"$TARGET\""; then
    log_line "  [OK]"
    PASS_COUNT=`expr $PASS_COUNT + 1`
    SUMMARY="$SUMMARY\n[OK]    Step 1: Updating Tricky Store packages"
else
    log_line "  [FAIL]"
    FAIL_COUNT=`expr $FAIL_COUNT + 1`
    SUMMARY="$SUMMARY\n[FAIL]  Step 1: Updating Tricky Store packages"
fi

# Step 2
start_step 2 "Refreshing fingerprint"
if [ -f "$PIF/autopif2.sh" ]; then
    FP_SCRIPT="$PIF/autopif2.sh"
elif [ -f "$PIF/autopif.sh" ]; then
    FP_SCRIPT="$PIF/autopif.sh"
else
    FP_SCRIPT=""
fi

if [ -n "$FP_SCRIPT" ]; then
    if run_cmd_capture "sh \"$FP_SCRIPT\""; then
        log_line "  [OK]"
        PASS_COUNT=`expr $PASS_COUNT + 1`
        SUMMARY="$SUMMARY\n[OK]    Step 2: Refreshing fingerprint"
    else
        log_line "  [FAIL]"
        FAIL_COUNT=`expr $FAIL_COUNT + 1`
        SUMMARY="$SUMMARY\n[FAIL]  Step 2: Refreshing fingerprint"
    fi
else
    log_line "  [FAIL] No fingerprint script found"
    FAIL_COUNT=`expr $FAIL_COUNT + 1`
    SUMMARY="$SUMMARY\n[FAIL]  Step 2: No fingerprint script found"
fi

# Step 3
start_step 3 "Applying Advanced settings to PIF"
if run_cmd_capture "sh \"$PIF/migrate.sh\" -a -f"; then
    log_line "  [OK]"
    PASS_COUNT=`expr $PASS_COUNT + 1`
    SUMMARY="$SUMMARY\n[OK]    Step 3: Applying Advanced settings"
else
    log_line "  [FAIL]"
    FAIL_COUNT=`expr $FAIL_COUNT + 1`
    SUMMARY="$SUMMARY\n[FAIL]  Step 3: Applying Advanced settings"
fi

# Step 4
start_step 4 "Updating Keybox"
if run_cmd_capture "sh \"$UPDATE\""; then
    log_line "  [OK]"
    PASS_COUNT=`expr $PASS_COUNT + 1`
    SUMMARY="$SUMMARY\n[OK]    Step 4: Updating Keybox"
else
    log_line "  [FAIL]"
    FAIL_COUNT=`expr $FAIL_COUNT + 1`
    SUMMARY="$SUMMARY\n[FAIL]  Step 4: Keybox Update"
fi

# Step 5
start_step 5 "Restarting GMS process"
log_line "  - Killing and restarting GMS process"
if run_cmd_capture "sh \"$KILL\""; then
    log_line "  [OK]"
    PASS_COUNT=`expr $PASS_COUNT + 1`
    SUMMARY="$SUMMARY\n[OK]    Step 5: Restarting GMS"
else
    log_line "  [FAIL]"
    FAIL_COUNT=`expr $FAIL_COUNT + 1`
    SUMMARY="$SUMMARY\n[FAIL]  Step 5: Restarting GMS"
fi

# Final summary 
log_line ""
log_line "========================================"
log_line "               SUMMARY                  "
log_line "========================================"
# print the collected summary lines
printf "%b\n" "$SUMMARY" | tee -a "$LOG"
log_line "----------------------------------------"
log_line "Passed: $PASS_COUNT"
log_line "Failed: $FAIL_COUNT"
log_line "Total:  $TOTAL_STEPS"
log_line "========================================"

handle_delay
exit 0