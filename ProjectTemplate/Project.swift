import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: projectName,
    options: .options(
        automaticSchemesOptions: .enabled(
            targetSchemesGrouping: .byNameSuffix(
                build: ["_Testing", "_Interface"],
                test: ["_Tests"],
                run: []
            ),
            codeCoverageEnabled: true,
            testLanguage: "cs",
            testRegion: "CZ"
        ),
        developmentRegion: "cs",
        textSettings: .textSettings(
            usesTabs: false,
            indentWidth: 4,
            tabWidth: 4,
            wrapsLines: true
        )
    ),
    settings: .settings(
        base: [
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "EAGER_LINKING": true,
            "ENABLE_MODULE_VERIFIER": true,
            "MARKETING_VERSION": .string(version.description),
            "OTHER_LDFLAGS": "-ObjC",
        ],
        configurations: [.current]
    ),
    targets: projectTargets
)
