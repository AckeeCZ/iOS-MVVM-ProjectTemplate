import AckeeTemplate
import Foundation
import ProjectDescription

private let targetName = "App"
private let bundleID = {
    if Configuration.current.isRelease {
        fatalError("TODO: Release bundleID not configured")
    }
    return "cz.ackee.ProjectTemplate.test"
}()
private let codeSigning = CodeSigning.current(
    bundleID: bundleID,
    teamID: .ackeeProduction
)

let app = Target(
    name: targetName,
    platform: .iOS,
    product: .app,
    bundleId: bundleID,
    deploymentTarget: .app,
    infoPlist: .extendingSharedDefault(with: [
        "ITSAppUsesNonExemptEncryption": false,
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
    ]),
    sources: "\(targetName)/Sources/**",
    resources: "\(targetName)/Resources/**",
    scripts: .crashlytics(),
    dependencies: [
        .core,
        .target(login),
        .target(profile),
        .target(userManager)
    ],
    settings: .settings(
        base: codeSigning.settings,
        configurations: [.current]
    )
)
