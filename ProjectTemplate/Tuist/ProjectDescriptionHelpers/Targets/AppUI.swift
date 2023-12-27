import Foundation
import ProjectDescription

private let targetName = "AppUI"
private let basePath = "Modules/" + targetName

let appUI = Target(
    name: targetName,
    destinations: .app,
    product: .framework,
    bundleId: "cz.ackee.\(projectName).\(targetName.toBundleID())",
    sources: .init(globs: [
        "\(basePath)/Sources/**",
        .testing(at: basePath)
    ].compactMap { $0 }),
    dependencies: [
        .assets,
        .ackeeTemplate
    ]
)

let appUITests = Target(
    name: appUI.name + "_Tests",
    destinations: .tests,
    product: .unitTests,
    bundleId: appUI.bundleId + ".tests",
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .appUI
    ]
)

public extension TargetDependency {
    static let appUI = TargetDependency.target(ProjectDescriptionHelpers.appUI)
}
