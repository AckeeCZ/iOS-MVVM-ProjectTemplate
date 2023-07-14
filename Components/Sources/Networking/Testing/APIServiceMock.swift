#if DEBUG
import Foundation

final class APIService_Mock: APIService {
    var requestBody: (URLRequest) async throws -> HTTPResponse = { _ in
        .init(request: nil, response: nil, data: nil)
    }

    func request(_ request: URLRequest) async throws -> HTTPResponse {
        try await requestBody(request)
    }
}
#endif
