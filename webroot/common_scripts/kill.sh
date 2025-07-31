#!/system/bin/sh

popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity > /dev/null
    sleep 0.5
}

kill_process() {
    TARGET="$1"
    PID=$(pidof "$TARGET")

    if [ -n "$PID" ]; then
        echo "- Found PID(s) for $TARGET: $PID"
        kill -9 $PID
        echo "- Killed $TARGET"
        echo "$TARGET process killed successfully"
    else
        echo "- $TARGET not running"
    fi
}

# Kill all
kill_process "com.google.android.gms.unstable"
kill_process "com.google.android.gms"
kill_process "com.android.vending"

popup "Process killed successfully"