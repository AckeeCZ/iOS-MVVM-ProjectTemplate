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
        developmentRegion: "CZ",
        textSettings: .textSettings(
            usesTabs: false,
            indentWidth: 4,
            tabWidth: 4,
            wrapsLines: true
        )
    ),
    settings: .settings(
        base: [
            "MARKETING_VERSION": .string(version.description)
        ],
        configurations: [.current]
    ),
    targets: projectTargets
)
