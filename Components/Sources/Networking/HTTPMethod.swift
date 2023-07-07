import Foundation

public enum HTTPMethod {
    case options
    case get
    case head
    case post
    case put
    case patch
    case delete
    case trace
    case connect
    case custom(String)
}

extension HTTPMethod: RawRepresentable {
    public var rawValue: String {
        switch self {
        case .options: return "OPTIONS"
        case .get: return "GET"
        case .head: return "HEAD"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        case .trace: return "TRACE"
        case .connect: return "CONNECT"
        case .custom(let method): return method
        }
    }
    
    public init?(rawValue: String) {
        self.init(stringLiteral: rawValue)
    }
}

extension HTTPMethod: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .custom(value)
    }
}
