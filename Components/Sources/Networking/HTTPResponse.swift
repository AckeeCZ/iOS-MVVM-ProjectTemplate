import Foundation

public struct HTTPResponse {
    /// Request that was sent
    public let request: URLRequest
    /// Received `HTTPURLResponse`
    public let response: HTTPURLResponse?
    /// Body of response
    public let data: Data?
    /// Shortcut to response status code
    public var statusCode: Int? { response?.statusCode }
    
    public init(
        request: URLRequest,
        response: HTTPURLResponse?,
        data: Data?
    ) {
        self.request = request
        self.response = response
        self.data = data
    }
    
    public func isAccepted(acceptedStatusCodes codes: [Int] = .init(200...299)) -> Bool {
        statusCode.map { codes.contains($0) } ?? true
    }
}
