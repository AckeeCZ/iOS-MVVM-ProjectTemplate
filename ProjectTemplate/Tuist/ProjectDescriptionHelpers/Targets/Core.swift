import Foundation
import ProjectDescription

private let targetName = "Core"
private let basePath = "Modules/" + targetName

let core = Target(
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

let coreTests = Target(
    name: core.name + "_Tests",
    platform: .iOS,
    product: .unitTests,
    bundleId: core.bundleId + ".tests",
    deploymentTarget: .tests,
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .core,
    ]
)

public extension TargetDependency {
    static let core = TargetDependency.target(ProjectDescriptionHelpers.core)
}
