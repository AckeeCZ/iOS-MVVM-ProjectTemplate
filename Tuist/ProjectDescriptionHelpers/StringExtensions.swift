import Foundation

public extension String {
    /// Convert `self` to valid bundle identifier
    var bundleID: String {
        // be naive for now
        replacingOccurrences(of: "_", with: "-")
    }
}
