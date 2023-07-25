#if DEBUG
import Foundation

final class APIService_Mock: APIServicing {
    var requestBody: (URLRequest) async throws -> HTTPResponse = {
        .init(request: $0, response: nil, data: nil)
    }

    func request(_ request: URLRequest) async throws -> HTTPResponse {
        try await requestBody(request)
    }
    
    func request(
        _ address: RequestAddress,
        method: HTTPMethod,
        query: [String: String]?,
        headers: [String: String]?,
        body: RequestBody?
    ) async throws -> HTTPResponse {
        let url: URL = {
            switch address {
            case .url(let url): return url
            case .path(let path):
                return .ackeeCZ.appendingPathComponent(path)
            }
        }()
        
        return try await request(.init(
            url: url,
            method: method,
            query: query,
            headers: headers,
            body: body
        ))
    }
}
#endif
