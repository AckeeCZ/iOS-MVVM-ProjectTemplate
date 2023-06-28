import Foundation

public extension String {
    /// Convert string to variant suitable to be used in bundle ID
    ///
    /// Useful when you wanna use target name (containing e.g. whitespaces) in bundleID
    func toBundleID() -> String {
        components(separatedBy: .alphanumerics.inverted).joined()
    }
}
