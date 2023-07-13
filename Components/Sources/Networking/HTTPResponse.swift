import Foundation

public struct HTTPResponse {
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?

    public var statusCode: Int? { response?.statusCode }
    
    public init(
        request: URLRequest?,
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
