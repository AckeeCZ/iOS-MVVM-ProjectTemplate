import Foundation
import ProjectDescription

private let targetName = "Profile"
private let basePath = "Modules/" + targetName

let profile = Target(
    name: targetName,
    platform: .iOS,
    product: .staticFramework,
    bundleId: "cz.ackee.\(projectName).\(targetName.toBundleID())",
    deploymentTarget: .app,
    sources: .init(globs: [
        "\(basePath)/Sources/**",
        .testing(at: basePath)
    ].compactMap { $0 }),
    dependencies: [
        .core,
        .ackeeTemplate,
        .appUI
    ]
)

let profileTests = Target(
    name: profile.name + "_Tests",
    platform: .iOS,
    product: .unitTests,
    bundleId: profile.bundleId + ".tests",
    deploymentTarget: .tests,
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .target(profile)
    ]
)
