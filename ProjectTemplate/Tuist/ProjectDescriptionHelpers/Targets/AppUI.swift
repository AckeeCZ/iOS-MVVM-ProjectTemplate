import Foundation
import ProjectDescription

private let targetName = "AppUI"
private let basePath = "Modules/" + targetName

let appUI = Target(
    name: targetName,
    platform: .iOS,
    product: .framework,
    bundleId: "cz.ackee.\(projectName).\(targetName.toBundleID())",
    deploymentTarget: .app,
    sources: .init(globs: [
        "\(basePath)/Sources/**",
        .testing(at: basePath),
    ].compactMap { $0 }),
    dependencies: [
        .assets,
    ]
)

let appUITests = Target(
    name: appUI.name + "_Tests",
    platform: .iOS,
    product: .unitTests,
    bundleId: appUI.bundleId + ".tests",
    deploymentTarget: .tests,
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .appUI,
    ]
)

public extension TargetDependency {
    static let appUI = TargetDependency.target(ProjectDescriptionHelpers.appUI)
}
