import Foundation

public struct HTTPResponse {
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?

    public var statusCode: Int? { response?.statusCode }
    public var headers: [String: String] { response?.allHeaderFields as? [String: String] ?? [:] }
    
    public func isAccepted(acceptedStatusCodes codes: [Int] = .init(200...299)) -> Bool {
        statusCode.map { codes.contains($0) } ?? true
    }
}

public struct UnexpectedStatusCodeError: Error {
    public let statusCode: Int
    
    public init(statusCode: Int) {
        self.statusCode = statusCode
    }
}

public extension Async<HTTPResponse> {
    func validate(acceptedStatusCodes codes: [Int] = .init(200...299)) -> Async<HTTPResponse> {
        attemptMap { response in
            guard let statusCode = response.statusCode else { return response }
            
            if response.isAccepted(acceptedStatusCodes: codes) {
                return response
            }
            throw UnexpectedStatusCodeError(statusCode: statusCode)
        }
    }
}
