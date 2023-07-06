import Foundation
import ProjectDescription

private let targetName = "Core"
private let basePath = "Modules/" + targetName

let core = Target(
    name: targetName,
    platform: .iOS,
    product: .framework,
    bundleId: "cz.ackee.\(projectName).core",
    deploymentTarget: .app,
    sources: .init(globs: [
        "\(basePath)/Sources/**",
        testing(at: basePath),
    ].compactMap { $0 })
)

let coreTests = Target(
    name: core.name + "_Tests",
    platform: .iOS,
    product: .unitTests,
    bundleId: core.bundleId + ".tests",
    deploymentTarget: .app,
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .core,
    ]
)
