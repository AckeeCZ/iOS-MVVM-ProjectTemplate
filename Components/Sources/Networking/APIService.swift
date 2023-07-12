import Foundation

public protocol APIService {
    func request(_ request: URLRequest) async throws -> HTTPResponse
}

public protocol RequestInterceptor {
    func intercept(
        service: APIService,
        request: inout URLRequest
    ) async throws
}

public protocol ResponseInterceptor {
    func intercept(
        service: APIService,
        response: inout HTTPResponse
    ) async throws
}
