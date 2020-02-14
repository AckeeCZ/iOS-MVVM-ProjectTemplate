import ProjectDescription

public enum AppCustomConfiguration {
    case debug, betaDevelopment, betaStage, betaProduction, release
    
    internal func customConfiguration(with name: String, projectVersion: Version) -> CustomConfiguration {
        switch self {
        case .debug:
            return CustomConfiguration.debug(name: configurationName, settings: settings(with: name, projectVersion: projectVersion))
        case .betaDevelopment, .betaProduction, .betaStage, .release:
            return CustomConfiguration.release(name: configurationName, settings: settings(with: name, projectVersion: projectVersion))
        }
    }
    
    internal func customTargetConfiguration(with name: String) -> CustomConfiguration {
        switch self {
        case .debug:
            return CustomConfiguration.debug(name: configurationName, settings: targetSettings(with: name))
        case .betaDevelopment, .betaProduction, .betaStage, .release:
            return CustomConfiguration.release(name: configurationName, settings: targetSettings(with: name))
        }
    }
    
    private var configurationName: String {
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
    
    private func settings(with name: String, projectVersion: Version) -> [String: SettingValue] {
        let base: [String: SettingValue] = [
            "ACK_ENVIRONMENT_DIR": "$(PROJECT_DIR)/$(TARGET_NAME)/Environment",
            "ACK_PROJECT_VERSION": SettingValue(stringLiteral: projectVersion.description),
            "DEVELOPMENT_TEAM": "PXDF48X6VX",
            "OTHER_LDFLAGS": "-ObjC",
            "ENABLE_BITCODE": "NO",
            "INFOPLIST_PREPROCESS": "YES",
            "INFOPLIST_PREFIX_HEADER": "$(ACK_ENVIRONMENT_DIR)/.environment_preprocess.h",
            "CODE_SIGN_STYLE": "Manual",
        ]
        
        switch self {
        case .debug:
            let debugSettings: [String: SettingValue] = [
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "ACK_APPNAME": SettingValue(stringLiteral: "\(name) Δ"),
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: "cz.ackee.enterprise.\(name).\(identifierName)"),
                "PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "match InHouse cz.ackee.enterprise.\(name).\(identifierName)"),
            ]
            return base.merging(debugSettings, uniquingKeysWith: { _, debug in debug })
        case .betaDevelopment, .betaProduction, .betaStage:
            let betaSettings: [String: SettingValue] = [
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "ADHOC",
                "ACK_APPNAME": SettingValue(stringLiteral: "\(name) β"),
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: "cz.ackee.enterprise.\(name).\(identifierName)"),
                "PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "match InHouse cz.ackee.enterprise.\(name).\(identifierName)"),
            ]
            return base.merging(betaSettings, uniquingKeysWith: { _, beta in beta })
        case .release:
            let releaseSettings: [String: SettingValue] = [
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "ADHOC",
                "ACK_APPNAME": SettingValue(stringLiteral: "\(name)"),
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: "cz.ackee.\(name)"),
                "PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "match InHouse cz.ackee.\(name)"),
            ]
            return base.merging(releaseSettings, uniquingKeysWith: { _, release in release })
        }
    }
    
    private var identifierName: String {
        switch self {
        case .debug:
            return "debug"
        case .betaDevelopment:
            return "development.beta"
        case .betaStage:
            return "stage.beta"
        case .betaProduction:
            return "production.beta"
        case .release:
            return "release"
        }
    }
    
    private func targetSettings(with name: String) -> [String: SettingValue] {
        switch self {
        case .debug:
            return ["CODE_SIGN_IDENTITY": "iPhone Developer"]
        case .betaDevelopment, .betaStage, .betaProduction, .release:
            return ["CODE_SIGN_IDENTITY": "iPhone Distribution"]
        }
    }
}

