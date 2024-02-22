import Foundation
import ProjectDescription

private let targetName = "Profile"
private let basePath = "Modules/" + targetName

let profile = Target(
    name: targetName,
    destinations: .app,
    product: .staticFramework,
    bundleId: "cz.ackee.\(projectName).\(targetName.toBundleID())",
    sources: .init(globs: [
        "\(basePath)/Sources/**",
        .testing(at: basePath)
    ].compactMap { $0 }),
    dependencies: [
        .core,
        .ackategories,
        .appUI
    ]
)

let profileTests = Target(
    name: profile.name + "Tests",
    destinations: .tests,
    product: .unitTests,
    bundleId: profile.bundleId + ".tests",
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .target(profile)
    ]
)
