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
    
    /// Determines if given response is error due to expired auth data (auth token basically)
    public let isExpiredAuthDataResponse: (HTTPResponse) async -> Bool
    /// Determines if given response and its request used current auth data (auth token basically).
    ///
    /// Based on that `refeshAuthData` could be called.
    public let requestUsedCurrentAuthData: (HTTPResponse) async -> OAuthInterceptor.UsedCurrentAuthData
    
    /// Closure that refreshes auth data (auth token basically) and returns a function that transforms received response (and its request)
    /// to new request so we can retry that request again with new auth data
    public let refreshAuthData: () async throws -> (HTTPResponse) -> (URLRequest)
    
    /// To prevent actor [re-entrancy issue](https://medium.com/@mark.moeykens/swift-actor-reentrancy-model-explained-11463d993c59)
    /// we track call to `refreshAuthData()` closure as it should never occur multiple times at once
    private var refreshTask: Task<(HTTPResponse) -> (URLRequest), Error>?
    
    /// Create new interceptor
    /// - Parameters:
    ///   - isExpiredAuthDataResponse: Determines if given response is error due to expired auth data (auth token basically)
    ///   - requestUsedCurrentAuthData: Determines if given response and its request used current auth data (auth token basically). Based on that `refeshAuthData` could be called.
    ///   - refreshAuthData: Closure that refreshes auth data (auth token basically) and returns a function that transforms received response (and its request) to new request so we can retry that request again with new auth data
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
