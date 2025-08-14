#!/system/bin/sh
nohup am start -a android.intent.action.VIEW -d https://android.googleapis.com/attestation/status >/dev/null 2>&1 &
echo "Redirecting to Google Revoked List"
exit 0