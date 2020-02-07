import ProjectDescription

extension Project {
    
    public static func project(name: String,
                               appName: String,
                               settings: CustomSettings = CustomSettings(configurations: [.debug,
                                                                                          .betaDevelopment,
                                                                                          .betaStage,
                                                                                          .betaProduction,
                                                                                          .release]),
                               product: Product,
                               platform: Platform,
                               deploymentTarget: DeploymentTarget = .iOS(targetVersion: "12.0", devices: [.iphone, .ipad]),
                               dependencies: [TargetDependency] = [],
                               infoPlist: [String: InfoPlist.Value] = [:]) -> Project {
        return Project(name: name,
                       settings: Settings(configurations: settings.customConfigurations(for: appName)),
                       targets: [
                        Target(name: name,
                                platform: platform,
                                product: product,
                                bundleId: "${ACK_BUNDLE_ID}",
                                deploymentTarget: deploymentTarget,
                                infoPlist: .extendingDefault(with: infoPlist),
                                sources: ["Sources/**"],
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
                                settings: Settings(configurations: [CustomConfiguration.debug(name: "Development", settings: ["Gibberish": "gibbb"])])),
                        Target(name: "\(name)Tests",
                                platform: platform,
                                product: .unitTests,
                                bundleId: "io.tuist.\(name)Tests",
                                infoPlist: .default,
                                sources: "Tests/**",
                                dependencies: [
                                    .target(name: "\(name)")
                                ])
                      ])
    }
    
    // MARK: - Helpers
    
    private static func scriptPath(path: String) -> Path {
        Path("BuildPhases/" + path)
    }
}

public struct CustomSettings {
    private let configurations: [AppCustomConfiguration]
    
    func customConfigurations(for name: String) -> [CustomConfiguration] {
        configurations.map { $0.customConfiguration(with: name) }
    }
    
    public init(configurations: [AppCustomConfiguration]) {
        self.configurations = configurations
    }
}


public enum AppCustomConfiguration {
    case debug, betaDevelopment, betaStage, betaProduction, release
    
    func customConfiguration(with name: String) -> CustomConfiguration {
        switch self {
        case .debug:
            return CustomConfiguration.debug(name: name, settings: settings(with: name))
        case .betaDevelopment, .betaProduction, .betaStage, .release:
            return CustomConfiguration.release(name: name, settings: settings(with: name))
        }
    }
    
    private var name: String {
        switch self {
        case .debug:
            return "Debug"
        case .betaDevelopment:
            return "Beta-Development"
        case .betaStage:
            return "Beta-Stage"
        case .betaProduction:
            return "Beta-Production"
        case .release:
            return "Release"
        }
    }
    
    private func settings(with name: String) -> [String: SettingValue] {
        switch self {
        case .debug:
            return generateSettings(for: .debug)
        case .betaDevelopment, .betaStage, .betaProduction:
            return generateSettings(for: .release)
        case .release:
            return generateSettings(for: .base)
        }
    }
}

private enum CustomConfigurationSettings {
    case debug, release, base, stripped
}

private func generateSettings(for customConfigurationSettings: CustomConfigurationSettings) -> [String: SettingValue] {
    let base: [String: SettingValue] = [
        "ACK_ENVIRONMENT_DIR": "$(PROJECT_DIR)/$(TARGET_NAME)/Environment",
        "ACK_PROJECT_VERSION": "0.0",
        "DEVELOPMENT_TEAM": "PXDF48X6VX",
        "OTHER_LDFLAGS": "-ObjC",
        "ENABLE_BITCODE": "NO",
        "INFOPLIST_PREPROCESS": "YES",
        "INFOPLIST_PREFIX_HEADER": "$(ACK_ENVIRONMENT_DIR)/.environment_preprocess.h",
    ]
    switch customConfigurationSettings {
    case .debug:
        let debugSettings: [String: SettingValue] = ["DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"]
        return base.merging(debugSettings, uniquingKeysWith: { _, debug in debug })
    case .release:
        let releaseSettings: [String: SettingValue] = ["SWIFT_ACTIVE_COMPILATION_CONDITIONS": "ADHOC"]
        return base.merging(releaseSettings, uniquingKeysWith: { _, release in release })
    case .base:
        return base
    case .stripped:
        let strippedSettings: [String: SettingValue] = ["INFOPLIST_PREPROCESS": "NO",
                                                        "INFOPLIST_PREFIX_HEADER": "",]
        return strippedSettings
    }
}
