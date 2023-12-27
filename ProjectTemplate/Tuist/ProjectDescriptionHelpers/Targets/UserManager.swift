import Foundation
import ProjectDescription

private let targetName = "UserManager"
private let basePath = "Modules/" + targetName

let userManager = Target(
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
        .ackeeTemplate
    ]
)

let userManagerTests = Target(
    name: userManager.name + "_Tests",
    destinations: .tests,
    product: .unitTests,
    bundleId: userManager.bundleId + ".tests",
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .target(userManager)
    ]
)
