import ProjectDescription

public extension Target {
    /// Create app target with our predefined folder structure
    ///
    /// Expects folder named `name` with subfolders **Environment** and **Resources**,
    ///
    /// All files in **Resources** are added to app as resources.
    ///
    /// **Environment** folder is expected to have _environment.plist_ in its root and _GoogleService-Info.plist_ specific for build configuration
    /// in separate folder for each configuration, e.g. for Debug configuration the path will be _Environment/Debug/GoogleService-Info.plist_
    static func app(
        name: String,
        platform: Platform,
        bundleID: String = "${PRODUCT_BUNDLE_IDENTIFIER}",
        deploymentTarget: DeploymentTarget? = nil,
        infoPlist: CustomInfoPlist,
        dependencies: [TargetDependency],
        settings: Settings?
    ) -> Target {
        let environmentDir = "\(name)/Environment/\(ProjectDescriptionHelpers.environment())"
        
        return Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: bundleID,
            deploymentTarget: deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist.value),
            sources: ["\(name)/Sources/**"],
            resources: [
                .glob(pattern: "\(environmentDir)/environment.plist"),
                .glob(pattern: "\(environmentDir)/\(configurationInfo().name)/GoogleService-Info.plist"),
                .glob(pattern: "\(name)/Resources/**"),
            ],
            actions: [
                .swiftlint(),
                .crashlytics()
            ],
            dependencies: dependencies,
            settings: settings
        )
    }
    
    /// Creates unit test target with our predefined structure
    ///
    /// Expects **Tests** folder inside `target.name` folder
    static func unitTests(for target: Target) -> Target {
        Target(
            name: "\(target.name)_Tests",
            platform: target.platform,
            product: .unitTests,
            bundleId: "\(target.bundleId)_Tests".bundleID,
            infoPlist: .default,
            sources: "\(target.name)/Tests/**",
            dependencies: [
                .target(name: target.name)
            ]
        )
    }
}
