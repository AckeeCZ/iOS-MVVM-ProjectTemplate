import Foundation
import ProjectDescription

private let targetName = "DesignSystem"
private let basePath = "Modules/" + targetName

let designSystem = Target(
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

let designSystemTests = Target(
    name: designSystem.name + "_Tests",
    platform: .iOS,
    product: .unitTests,
    bundleId: designSystem.bundleId + ".tests",
    deploymentTarget: .tests,
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .designSystem,
    ]
)

public extension TargetDependency {
    static let designSystem = TargetDependency.target(ProjectDescriptionHelpers.designSystem)
}
