import Foundation

/// Represents team ID in Apple Dev portal & App Store Connect,
/// basically just provides namespace for your own extensions.
public struct TeamID: RawRepresentable, CustomStringConvertible, ExpressibleByStringInterpolation {
    /// Team ID for Ackee production apps
    public static let ackeeProduction: Self = "3SMVP6VZP8"
    
    public var rawValue: String
    public var description: String { rawValue }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
