import ProjectDescription

extension Project {
    public static func project(
        name: String,
        settings: CustomSettings = CustomSettings(configurations: [configuration()]),
        projectVersion: Version = Version(0, 1, 0),
        platform: Platform,
        deploymentTarget: DeploymentTarget = .iOS(targetVersion: "12.0", devices: [.iphone, .ipad]),
        dependencies: [TargetDependency] = [],
        infoPlist: CustomInfoPlist = .default
    ) -> Project {
        let environmentDir = "\(name)/Environment/\(environment())"
        
        return Project(
            name: name,
            settings: Settings(configurations: settings.customConfigurations(for: name, projectVersion: projectVersion)),
            targets: [
                Target(
                    name: name,
                    platform: platform,
                    product: .app,
                    bundleId: "${PRODUCT_BUNDLE_IDENTIFIER}",
                    deploymentTarget: deploymentTarget,
                    infoPlist: .extendingDefault(with: infoPlist.value),
                    sources: [SourceFileGlob(stringLiteral: "\(name)/Sources/**")],
                    resources: [
                        .glob(pattern: "\(environmentDir)/environment.plist"),
                        .glob(pattern: "\(environmentDir)/\(configuration().rawValue)/GoogleService-Info.plist"),
                        .glob(pattern: "\(name)/Resources/**"),
                    ],
                    actions: [
                        .swiftlint(),
                        .crashlytics()
                    ],
                    dependencies: dependencies,
                    settings: Settings(configurations: settings.targetCustomConfiguration(for: name))),
                Target(
                    name: "\(name)_Tests",
                    platform: platform,
                    product: .unitTests,
                    bundleId: "cz.ackee.\(name)_Tests".bundleID,
                    infoPlist: .default,
                    sources: "\(name)/Tests/**",
                    dependencies: [
                        .target(name: "\(name)")
                    ]
                )
            ]
        )
    }
}
