RUN_SCRIPT_URL="https://raw.githubusercontent.com/firebase/firebase-ios-sdk/master/Crashlytics/run"
UPLOAD_DSYM_URL="https://raw.githubusercontent.com/firebase/firebase-ios-sdk/master/Crashlytics/upload-symbols"
RUN_SCRIPT_DST_DIR="$PROJECT_DIR/Carthage/Build"
RUN_SCRIPT_DST="$RUN_SCRIPT_DST_DIR/run"
UPLOAD_DSYM_DST="$RUN_SCRIPT_DST_DIR/upload-symbols"

if [ -f "$RUN_SCRIPT_DST" ]; then
    "$RUN_SCRIPT_DST"
else 
    cd "$RUN_SCRIPT_DST_DIR"
    curl -O "$RUN_SCRIPT_URL"
    curl -O "$UPLOAD_DSYM_URL"
    cd "-"
    chmod +x "$RUN_SCRIPT_DST" 
    chmod +x "$UPLOAD_DSYM_DST"
    "$RUN_SCRIPT_DST"
    "$UPLOAD_DSYM_DST"
fi
