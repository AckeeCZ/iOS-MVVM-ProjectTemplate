import Foundation
import ProjectDescription

private let targetName = "Assets"
private let basePath = "Modules/" + targetName

let assets = Target(
    name: targetName,
    platform: .iOS,
    product: .framework,
    bundleId: "cz.ackee.\(projectName).\(targetName.toBundleID())",
    deploymentTarget: .app,
    resources: "\(basePath)/Resources/**"
)

public extension TargetDependency {
    static let assets = TargetDependency.target(ProjectDescriptionHelpers.assets)
}
