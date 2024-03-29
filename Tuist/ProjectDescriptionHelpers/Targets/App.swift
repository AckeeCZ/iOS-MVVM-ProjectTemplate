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
    destinations: .app,
    product: .app,
    bundleId: bundleID,
    infoPlist: .extendingSharedDefault(with: [
        "ITSAppUsesNonExemptEncryption": false,
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
    ]),
    sources: "\(targetName)/Sources/**",
    resources: [
        "\(targetName)/Resources/**",
        "\(targetName)/GoogleService/\(bundleID)/GoogleService-Info.plist",
    ],
    scripts: .crashlytics(),
    dependencies: [
        .core,
        .target(login),
        .target(profile),
        .target(userManager),
    ] + .firebase,
    settings: .settings(
        base: codeSigning.settings,
        configurations: [.current]
    )
)
