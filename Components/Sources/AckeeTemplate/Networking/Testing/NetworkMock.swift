#if DEBUG
import Foundation

final class Network_Mock: Networking {
    var requestBody: (URLRequest) async throws -> HTTPResponse = { _ in .test() }
    
    func request(_ request: URLRequest) async throws -> HTTPResponse {
        try await requestBody(request)
    }
}
#endif
