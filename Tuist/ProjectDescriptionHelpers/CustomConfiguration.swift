import ProjectDescription

public extension SettingsDictionary {
    static let base: SettingsDictionary = [
        "CODE_SIGN_STYLE": "Manual",
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        "DEVELOPMENT_TEAM": "PXDF48X6VX",
        "ENABLE_BITCODE": "NO",
        "OTHER_LDFLAGS": "-ObjC",
    ]
    
    static let beta = base.merging(
        [
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "ADHOC",
        ],
        uniquingKeysWith: { $1 }
    )
    
    static let release: SettingsDictionary = {
        var releaseDict = base
        releaseDict.removeValue(forKey: "SWIFT_ACTIVE_COMPILATION_CONDITIONS")
        return releaseDict
    }()
    
    func addingAppName(_ name: String) -> SettingsDictionary {
        merging(["ACK_APP_NAME": .string(name)], uniquingKeysWith: { $1 })
    }
    
    func addingProjectVersion(_ version: Version) -> SettingsDictionary {
        merging(["ACK_PROJECT_VERSION": .string(version.description)], uniquingKeysWith: { $1 })
    }
}

public extension CustomConfiguration {
    static let debug = CustomConfiguration.debug(name: "Debug", settings: .base)
    static let betaDev = CustomConfiguration.release(name: "Beta-Dev", settings: .beta)
    static let betaStage = CustomConfiguration.release(name: "Beta-Stage", settings: .beta)
    static let betaProduction = CustomConfiguration.release(name: "Beta-Production", settings: .beta)
    static let release = CustomConfiguration.release(name: "Release", settings: .release)
}

public struct CustomConfigurationInfo: CaseIterable {
    public static var allCases: [CustomConfigurationInfo] = [
        debug,
        .init(
            configuration: .betaDev,
            codeSignIdentity: "iPhone Distribution",
            provisioningProfileSpecifier: "match InHouse cz.ackee.enterprise.*",
            appNameFromName: { "\($0) β" },
            bundleIDFromName: { "cz.ackee.enterprise.\($0.bundleID).development.beta" }
        ),
        .init(
            configuration: .betaStage,
            codeSignIdentity: "iPhone Distribution",
            provisioningProfileSpecifier: "match InHouse cz.ackee.enterprise.*",
            appNameFromName: { "\($0) β" },
            bundleIDFromName: { "cz.ackee.enterprise.\($0.bundleID).stage.beta" }
        ),
        .init(
            configuration: .betaProduction,
            codeSignIdentity: "iPhone Distribution",
            provisioningProfileSpecifier: "match InHouse cz.ackee.enterprise.*",
            appNameFromName: { "\($0) β" },
            bundleIDFromName: { "cz.ackee.enterprise.\($0.bundleID).production.beta" }
        ),
        .init(
            configuration: .release,
            codeSignIdentity: "iPhone Distribution",
            provisioningProfileSpecifier: "match AppStore $PRODUCT_BUNDLE_IDENTIFIER",
            appNameFromName: { $0 },
            bundleIDFromName: { "cz.ackee.\($0)" }
        ),
    ]
    
    public static let debug = CustomConfigurationInfo(
        configuration: .debug,
        codeSignIdentity: "iPhone Developer",
        provisioningProfileSpecifier: "match Development cz.ackee.enterprise.*",
        appNameFromName: { "\($0) Δ" },
        bundleIDFromName: { "cz.ackee.enterprise.\($0.bundleID).debug" }
    )
    
    public let configuration: CustomConfiguration
    public let codeSignIdentity: String
    public let provisioningProfileSpecifier: String
    public let appNameFromName: (String) -> String
    public let bundleIDFromName: (String) -> String
    
    public var name: String { configuration.name }
    
    public func settingsDictionary(name: String) -> SettingsDictionary {
        [
            "ACK_APPNAME": .string(appNameFromName(name)),
            "CODE_SIGN_IDENTITY": .string(codeSignIdentity),
            "PRODUCT_BUNDLE_IDENTIFIER": .string(bundleIDFromName(name)),
            "PROVISIONING_PROFILE_SPECIFIER": .string(provisioningProfileSpecifier),
        ]
    }
}
