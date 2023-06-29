import Foundation

public struct TeamID: RawRepresentable, CustomStringConvertible, ExpressibleByStringInterpolation {
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
