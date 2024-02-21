import Foundation
import ProjectDescription

private let targetName = "FirebaseFetcher"
private let basePath = "Modules/" + targetName

let firebaseFetcher = Target(
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
    ] + .firebase
)
