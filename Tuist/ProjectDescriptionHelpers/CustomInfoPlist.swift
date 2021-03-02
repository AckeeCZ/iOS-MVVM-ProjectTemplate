import ProjectDescription

/// Custom Info.plist
public enum CustomInfoPlist {
    /// Use custom .plist
    case custom([String: InfoPlist.Value])
    /// Extend default
    case extendingDefault([String: InfoPlist.Value])
    /// Default
    case `default`
    
    internal var value: [String: InfoPlist.Value] {
        let defaultInfoPlist: [String: InfoPlist.Value] = [
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "CFBundleShortVersionString": "$(ACK_PROJECT_VERSION)",
            "CFBundleDisplayName": "$(ACK_APPNAME)",
        ]
        switch self {
        case let .custom(infoPlist):
            return infoPlist
        case let .extendingDefault(infoPlist):
            return infoPlist.merging(defaultInfoPlist, uniquingKeysWith: { custom, _ in custom })
        case .default:
            return defaultInfoPlist
        }
    }
}
