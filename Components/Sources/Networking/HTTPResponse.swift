import Foundation

public struct HTTPResponse {
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?

    public var statusCode: Int? { response?.statusCode }
    public var headers: [String: String] { response?.allHeaderFields as? [String: String] ?? [:] }
}

