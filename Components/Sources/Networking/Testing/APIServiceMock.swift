#if DEBUG
import Foundation

final class APIService_Mock: APIService {
    var requestBody: (URLRequest) async throws -> HTTPResponse = {
        .init(request: $0, response: nil, data: nil)
    }

    func request(_ request: URLRequest) async throws -> HTTPResponse {
        try await requestBody(request)
    }
}
#endif
