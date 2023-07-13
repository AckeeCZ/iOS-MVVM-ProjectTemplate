import Foundation

public protocol Networking {
    func request(_ request: URLRequest) async throws -> HTTPResponse
}

public protocol HasNetwork {
    var network: Networking { get }
}

extension URLSession: Networking {
    public func request(_ request: URLRequest) async throws -> HTTPResponse {
        let (data, response) = try await data(for: request)
        
        return .init(
            request: request,
            response: response as? HTTPURLResponse,
            data: data
        )
    }
}
