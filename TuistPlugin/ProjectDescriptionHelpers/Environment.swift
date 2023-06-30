import Foundation
import enum ProjectDescription.Environment

/// Representing app environments
///
/// Represents standard environments in our app,
/// if you need custom environments, you should use your own object.
public enum Environment: String, CaseIterable {
    public static var current: Self {
        .init(
            rawValue: ProjectDescription.Environment.environment
                .getString(default: "Development")
        ) ?? .development
    }
    
    /// Development for development 😎 and maybe sometimes testing
    case development = "Development"
    /// Stage for testing
    case stage = "Stage"
    /// Production for release builds
    case production = "Production"
}

extension Environment: CustomStringConvertible {
    public var description: String { rawValue }
}

public extension Environment {
    /// Suffix that can help distinguish between environments in app name
    var appNameSuffix: String { String(rawValue.first!) }
    
    init?(rawValue: String) {
        if let value = Self.allCases.first(where: { $0.rawValue.lowercased() == rawValue.lowercased() }) {
            self = value
        }
        return nil
    }
}
