popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity > /dev/null
    sleep 0.5
}

nohup am start -a android.intent.action.VIEW -d https://github.com/MeowDump/Integrity-Box >/dev/null 2>&1 & 
popup "Redirecting to Source Code repo"

exit 0