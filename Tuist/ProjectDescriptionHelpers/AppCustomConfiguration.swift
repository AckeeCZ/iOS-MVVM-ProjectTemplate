import ProjectDescription

public enum AppCustomConfiguration: String {
    case debug = "Debug"
    case betaDevelopment = "Beta-Dev"
    case betaStage = "Beta-Stage"
    case betaProduction = "Beta-Production"
    case release = "Release"
    
    internal func customConfiguration(with name: String, projectVersion: Version) -> CustomConfiguration {
        switch self {
        case .debug:
            return CustomConfiguration.debug(name: rawValue, settings: settings(with: name, projectVersion: projectVersion))
        case .betaDevelopment, .betaProduction, .betaStage, .release:
            return CustomConfiguration.release(name: rawValue, settings: settings(with: name, projectVersion: projectVersion))
        }
    }
    
    internal func customTargetConfiguration(with name: String) -> CustomConfiguration {
        switch self {
        case .debug:
            return CustomConfiguration.debug(name: rawValue, settings: targetSettings(with: name))
        case .betaDevelopment, .betaProduction, .betaStage, .release:
            return CustomConfiguration.release(name: rawValue, settings: targetSettings(with: name))
        }
    }
    
    private func settings(with name: String, projectVersion: Version) -> [String: SettingValue] {
        let base: [String: SettingValue] = [
            "ACK_PROJECT_VERSION": .string(projectVersion.description),
            "CODE_SIGN_STYLE": "Manual",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "DEVELOPMENT_TEAM": "PXDF48X6VX",
            "ENABLE_BITCODE": "NO",
            "OTHER_LDFLAGS": "-ObjC",
        ]
        
        let bundleName = name.bundleID
        
        switch self {
        case .debug:
            let debugSettings: [String: SettingValue] = [
                "ACK_APPNAME": "\(name) Δ",
                "PRODUCT_BUNDLE_IDENTIFIER": "cz.ackee.enterprise.\(bundleName).\(identifierName)",
                "PROVISIONING_PROFILE_SPECIFIER": "match InHouse cz.ackee.enterprise.\(name).\(identifierName)",
            ]
            return base.merging(debugSettings, uniquingKeysWith: { _, debug in debug })
        case .betaDevelopment, .betaProduction, .betaStage:
            let betaSettings: [String: SettingValue] = [
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "ADHOC",
                "ACK_APPNAME": "\(name) β",
                "PRODUCT_BUNDLE_IDENTIFIER": "cz.ackee.enterprise.\(bundleName).\(identifierName)",
                "PROVISIONING_PROFILE_SPECIFIER": "match InHouse cz.ackee.enterprise.\(bundleName).\(identifierName)",
            ]
            return base.merging(betaSettings, uniquingKeysWith: { _, beta in beta })
        case .release:
            let releaseSettings: [String: SettingValue] = [
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "",
                "ACK_APPNAME": .string(name),
                "PRODUCT_BUNDLE_IDENTIFIER": "cz.ackee.\(bundleName)",
                "PROVISIONING_PROFILE_SPECIFIER": "match InHouse cz.ackee.\(bundleName)",
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

