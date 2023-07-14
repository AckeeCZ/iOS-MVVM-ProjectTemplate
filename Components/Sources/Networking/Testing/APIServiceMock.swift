#if DEBUG
import Foundation

final class APIService_Mock: APIServicing {
    var requestBody: (URLRequest) async throws -> HTTPResponse = {
        .init(request: $0, response: nil, data: nil)
    }

    func request(_ request: URLRequest) async throws -> HTTPResponse {
        try await requestBody(request)
    }
}
#endif
