#!/bin/sh

touch "${ACK_ENVIRONMENT_DIR}/.current"

cd "${PROJECT_DIR}/BuildPhases"

echo "Running environment switch"
./EnvironmentSwitch.sh

echo "Selecting correct Google plist"
./SelectGooglePlist.sh

echo "Running SwiftGen"
./SwiftGen.sh

cd -