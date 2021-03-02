#!/bin/sh

mint run LicensePlist \
    --output-path "${PROJECT_DIR}/${TARGET_NAME}/Settings.bundle" \
    --prefix Licenses \
    --pods-path "${PROJECT_DIR}/Pods/" \
    --cartfile-path "${PROJECT_DIR}/Cartfile"
