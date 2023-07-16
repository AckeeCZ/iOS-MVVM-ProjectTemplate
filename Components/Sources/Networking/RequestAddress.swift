import Foundation

public enum RequestAddress {
    case url(URL)
    case path(String)
}

extension RequestAddress: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        if let url = URL(string: value),
           let scheme = url.scheme,
           !scheme.isEmpty {
            self = .url(url)
        } else {
            self = .path(value)
        }
    }
}
