import Foundation
import ProjectDescription

private let targetName = "Login"
private let basePath = "Modules/" + targetName

let login = Target(
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

let loginTests = Target(
    name: login.name + "_Tests",
    platform: .iOS,
    product: .unitTests,
    bundleId: login.bundleId + ".tests",
    deploymentTarget: .tests,
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .target(login)
    ]
)
