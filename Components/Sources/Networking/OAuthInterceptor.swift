import Foundation

/// Interceptor that is ready to solve token refresh
public final actor OAuthInterceptor: ResponseInterceptor {
    /// Enum for results when checking if request current auth data
    public enum UsedCurrentAuthData {
        /// Request used current auth data
        case yes
        /// Request did not use current auth data and should use
        /// given URLRequest to retry
        case no(URLRequest)
    }
    
    public let isExpiredAuthDataResponse: (HTTPResponse) async -> Bool
    public let requestUsedCurrentAuthData: (HTTPResponse) async -> OAuthInterceptor.UsedCurrentAuthData
    public let refreshAuthData: () async throws -> (HTTPResponse) -> (URLRequest)
    
    private var refreshTask: Task<(HTTPResponse) -> (URLRequest), Error>?
    
    public init(
        isExpiredAuthDataResponse: @escaping (HTTPResponse) async -> Bool,
        requestUsedCurrentAuthData: @escaping (HTTPResponse) async -> UsedCurrentAuthData,
        refreshAuthData: @escaping () async throws -> (HTTPResponse) -> (URLRequest)
    ) {
        self.isExpiredAuthDataResponse = isExpiredAuthDataResponse
        self.requestUsedCurrentAuthData = requestUsedCurrentAuthData
        self.refreshAuthData = refreshAuthData
    }
    
    public func intercept(
        service: APIServicing,
        response originalResponse: inout HTTPResponse
    ) async throws {
        guard await isExpiredAuthDataResponse(originalResponse) else {
            return
        }
        
        switch await requestUsedCurrentAuthData(originalResponse) {
        case .yes:
            let task = refreshTask ?? .init {
                defer { refreshTask = nil }
                return try await refreshAuthData()
            }

            refreshTask = task
            
            let newRequest = try await task.value(originalResponse)
            originalResponse = try await service.request(newRequest)
        case .no(let newRequest):
            originalResponse = try await service.request(newRequest)
        }
    }
}
