import Foundation
import ProjectDescription

private let targetName = "Core"
private let basePath = "Modules/" + targetName

let core = Target(
    name: targetName,
    destinations: .app,
    product: .framework,
    bundleId: "cz.ackee.\(projectName).\(targetName.toBundleID())",
    sources: .init(globs: [
        "\(basePath)/Sources/**",
        .testing(at: basePath, isDebug: true)
    ].compactMap { $0 }),
    dependencies: [
        .assets,
        .ackategories,
    ]
)

let coreTests = Target(
    name: core.name + "_Tests",
    destinations: .tests,
    product: .unitTests,
    bundleId: core.bundleId + ".tests",
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .core
    ]
)

public extension TargetDependency {
    static let core = TargetDependency.target(ProjectDescriptionHelpers.core)
}
