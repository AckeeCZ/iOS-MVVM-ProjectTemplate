#!/bin/sh

SRC="${ACK_ENVIRONMENT_DIR}/Current/GoogleService/GoogleService-Info-${CONFIGURATION}.plist"
DST="${ACK_ENVIRONMENT_DIR}/Current/GoogleService-Info.plist"

cp "$SRC" "$DST"
touch "$DST"
