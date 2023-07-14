import Foundation

/// Protocol wrapping objects that perform network requests
public protocol APIServicing {
    /// Send given `URLRequest`
    /// - Parameter request: Request to be sent
    /// - Returns: HTTPResponse to given request
    func request(_ request: URLRequest) async throws -> HTTPResponse
}

/// Protocol wrapping interceptors that can modify requests before they are sent
public protocol RequestInterceptor {
    /// Intercept request sent by service
    /// - Parameters:
    ///   - service: Service that wants to send given request
    ///   - request: Request that should be sent and can be modified
    func intercept(
        service: APIServicing,
        request: inout URLRequest
    ) async throws
}

/// Protocol wrapping interceptors that can modify responses before they are returned from API service
public protocol ResponseInterceptor {
    /// Intercept response that was returned to service
    /// - Parameters:
    ///   - service: Service that received given response
    ///   - response: Response that was received and can be modified
    func intercept(
        service: APIServicing,
        response: inout HTTPResponse
    ) async throws
}
