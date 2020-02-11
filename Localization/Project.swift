import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "Localization", targets: [
    Target(name: "Localization",
           platform: .iOS,
           product: .framework,
           bundleId: "localization",
           infoPlist: .default,
           actions: [.pre(tool: "sh",
                          arguments: "localization.sh",
                          name: "Run ACKLocalization")])])
