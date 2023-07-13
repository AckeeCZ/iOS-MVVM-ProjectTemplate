import Foundation

public actor OAuthInterceptor: ResponseInterceptor {
    public enum UsedCurrentAuthData {
        case yes, no(URLRequest)
    }
    
    public let isExpiredAuthDataResponse: (HTTPResponse) async -> Bool
    public let requestUsedCurrentAuthData: (HTTPResponse) async -> UsedCurrentAuthData
    public let refreshAuthData: (HTTPResponse) async throws -> URLRequest
    
    public init(
        isExpiredAuthDataResponse: @escaping (HTTPResponse) async -> Bool,
        requestUsedCurrentAuthData: @escaping (HTTPResponse) async -> UsedCurrentAuthData,
        refreshAuthData: @escaping (HTTPResponse) async throws -> URLRequest
    ) {
        self.isExpiredAuthDataResponse = isExpiredAuthDataResponse
        self.requestUsedCurrentAuthData = requestUsedCurrentAuthData
        self.refreshAuthData = refreshAuthData
    }
    
    public func intercept(
        service: APIService,
        response originalResponse: inout HTTPResponse
    ) async throws {
        guard await isExpiredAuthDataResponse(originalResponse) else { return }
        
        switch await requestUsedCurrentAuthData(originalResponse) {
        case .yes:
            let newRequest = try await refreshAuthData(originalResponse)
            originalResponse = try await service.request(newRequest)
        case .no(let newRequest):
            originalResponse = try await service.request(newRequest)
        }
    }
}
