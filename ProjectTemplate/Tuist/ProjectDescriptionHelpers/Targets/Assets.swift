import Foundation
import ProjectDescription

private let targetName = "Assets"
private let basePath = "Modules/" + targetName

let assets = Target(
    name: targetName,
    destinations: .app,
    product: .framework,
    bundleId: "cz.ackee.\(projectName).\(targetName.toBundleID())",
    resources: "\(basePath)/Resources/**"
)

public extension TargetDependency {
    static let assets = TargetDependency.target(ProjectDescriptionHelpers.assets)
}
