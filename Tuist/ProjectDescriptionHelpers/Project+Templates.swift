import ProjectDescription

extension Project {
    public static func project(name: String,
                               settings: CustomSettings = CustomSettings(configurations: [.debug,
                                                                                          .betaDevelopment,
                                                                                          .betaStage,
                                                                                          .betaProduction,
                                                                                          .release]),
                               projectVersion: Version = Version(0, 1, 0),
                               platform: Platform,
                               deploymentTarget: DeploymentTarget = .iOS(targetVersion: "12.0", devices: [.iphone, .ipad]),
                               dependencies: [TargetDependency] = [],
                               infoPlist: CustomInfoPlist = .default,
                               schemes: [AppCustomScheme] = [.development, .stage, .production]) -> Project {
        return Project(name: name,
                       settings: Settings(configurations: settings.customConfigurations(for: name, projectVersion: projectVersion)),
                       targets: [
                        Target(name: name,
                                platform: platform,
                                product: .app,
                                bundleId: "${ACK_BUNDLE_ID}",
                                deploymentTarget: deploymentTarget,
                                infoPlist: .extendingDefault(with: infoPlist.value),
                                sources: [SourceFileGlob(stringLiteral: "\(name)/**")],
                                resources: [
                                    .glob(pattern: Path("\(name)/Environment/Current/**")),
                                    .glob(pattern: Path("\(name)/Resources/**")),
                                ],
                                actions: [.pre(path: scriptPath(path: "All.sh"),
                                             name: "Pre-build",
                                             inputPaths: [Path("Environment/.current")],
                                             outputFileListPaths: [Path("BuildPhases/AllOutputFiles.xcfilelist")]),
                                         .post(path: scriptPath(path: "swiftlint.sh"),
                                              name: "Swiftlint"),
                                         .post(path: scriptPath(path: "crashlytics.sh"),
                                              name: "Crashlytics"),
                                ],
                                dependencies: dependencies,
                                settings: Settings(configurations: settings.targetCustomConfiguration(for: name))),
                        Target(name: "\(name)Tests",
                                platform: platform,
                                product: .unitTests,
                                bundleId: "cz.ackee.\(name)Tests",
                                infoPlist: .default,
                                sources: "Tests/**",
                                dependencies: [
                                    .target(name: "\(name)")
                                ])],
                       schemes: schemes.map { $0.customScheme(with: name) })
    }
    
    // MARK: - Helpers
    
    private static func scriptPath(path: String) -> Path {
        Path("BuildPhases/" + path)
    }
}

public extension TargetDependency {
    static func carthage(name: String, platform: Platform = .iOS) -> TargetDependency {
        .framework(path: Path("Carthage/Build/\(platform.rawValue)/\(name).framework"))
    }
}
