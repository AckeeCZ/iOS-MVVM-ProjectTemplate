import ProjectDescription

public extension TargetScript {
    static func crashlytics() -> TargetScript {
        .post(
            path: "BuildPhases/run",
            name: "Crashlytics",
            inputPaths: [
                "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
                "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
            ],
            basedOnDependencyAnalysis: false
        )
    }

    static func setBuildNumber() -> TargetScript {
        .post(
            script: """
            echo "Updating build number"

            cd "$SRCROOT"

            COMMITS=`git rev-list HEAD --count`

            if [ $? -ne 0 ]; then
                echo "error: Unable to get commits count, make sure you run project from git repo, or comment out this build phase"
                exit 1
            else
                echo "Number of commits $COMMITS"
            fi

            echo "Updating Info.plist at ${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

            # Update build number in created binary's Info.plist
            /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $COMMITS" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

            if [ $? -ne 0 ]; then
                # this write can fail as plist might not be present
                echo "error: Unable to write binary plist"
            else
                echo "Binary plist written"
            fi

            echo "Updating Info.plist at ${INFOPLIST_FILE}"

            # Update build number in original plist so it is consistent
            /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $COMMITS" "$INFOPLIST_FILE"

            if [ $? -ne 0 ]; then
                echo "error: Unable to write local plist"
                exit 3
            else
                echo "Local plist written"
            fi

            echo "Updating build finished"
            """,
            name: "Set build number",
            basedOnDependencyAnalysis: false
        )
    }

    
    /// Action that tries to run Swiftlint using mint, or directly if mint is not installed
    ///
    /// If Swiftlint cannot be found, then it does nothing
    static func swiftlint() -> TargetScript {
        .post(
            script: """
            export PATH=/opt/homebrew/bin:${PATH}

            set -e

            if ! [ -f ".swiftlint.yml" ]; then
                echo "No swiftlint.yml found, not running it"
                exit 0
            fi

            if command -v mint &> /dev/null && grep -iq swiftlint Mintfile; then
                echo "Mint"
                pushd "$SRCROOT"
                xcrun --sdk macosx mint run swiftlint --fix
                xcrun --sdk macosx mint run swiftlint
                popd
                exit 0
            fi

            if command -v "swiftlint" &> /dev/null; then
                echo "Direct"
                pushd "$SRCROOT"
                xcrun --sdk macosx swiftlint --fix
                xcrun --sdk macosx swiftlint
                popd
                exit 0
            fi

            echo "SwiftLint not found, not running it"
            """,
            name: "SwiftLint",
            basedOnDependencyAnalysis: false
        )
    }
}

