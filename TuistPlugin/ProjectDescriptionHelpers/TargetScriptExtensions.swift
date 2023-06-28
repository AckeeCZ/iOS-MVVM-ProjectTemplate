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
            path: "BuildPhases/SetBuildNumber.sh",
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

