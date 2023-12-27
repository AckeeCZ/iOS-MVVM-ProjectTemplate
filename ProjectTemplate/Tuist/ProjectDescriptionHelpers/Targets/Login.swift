import Foundation
import ProjectDescription

private let targetName = "Login"
private let basePath = "Modules/" + targetName

let login = Target(
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
        .ackeeTemplate,
        .appUI
    ]
)

let loginTests = Target(
    name: login.name + "_Tests",
    destinations: .tests,
    product: .unitTests,
    bundleId: login.bundleId + ".tests",
    sources: "\(basePath)/Tests/**",
    dependencies: [
        .xctest,
        .target(login)
    ]
)
