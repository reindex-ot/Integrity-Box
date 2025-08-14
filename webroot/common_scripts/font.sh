#!/system/bin/sh

FILES="
/data/adb/modules/integrity_box/webroot/meowna.ttf
/data/adb/modules/integrity_box/webroot/mona.ttf
/data/adb/modules/integrity_box/webroot/game/Mona.otf
"

for FILE in $FILES; do
    if [ -f "$FILE.bak" ]; then
        mv "$FILE.bak" "$FILE"
        echo "Restored: $FILE"
    elif [ -f "$FILE" ]; then
        # If original exists, append .bak
        mv "$FILE" "$FILE.bak"
        echo "Renamed to: $FILE.bak"
    else
        echo "Not found: $FILE"
    fi
done