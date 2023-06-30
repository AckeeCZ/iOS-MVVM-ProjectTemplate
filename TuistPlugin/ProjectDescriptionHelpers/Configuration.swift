import Foundation
import ProjectDescription

public extension Configuration {
    /// Current configuration based on `TUIST_ENVIRONMENT` variable
    ///
    /// If no `TUIST_ENVIRONMENT` is given, debug configuration is used
    static var current: Self {
        let rawValue = ProjectDescription.Environment.configuration.getString(default: "debug").lowercased()
        let settings: SettingsDictionary = [
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": .string(rawValue.uppercased()),
        ]
        
        switch rawValue {
        case "debug": return .debug(name: "Debug", settings: settings)
        case "beta": return .release(name: "Beta", settings: settings)
        case "release": return .release(name: "Release", settings: settings)
        default: return .debug(name: "Debug", settings: settings)
        }
    }
    
    /// Check if configuration is `.debug`
    var isDebug: Bool { name.rawValue.lowercased() == "debug" }
    
    /// Check if configuration is `.beta`
    var isBeta: Bool { name.rawValue.lowercased() == "beta" }
    
    /// Check if configuration is `.release`
    var isRelease: Bool { name.rawValue.lowercased() == "release" }
}

extension Configuration: CustomStringConvertible {
    public var description: String { name.rawValue }
}
