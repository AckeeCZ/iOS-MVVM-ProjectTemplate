import Foundation

public struct UnexpectedStatusCodeError: Error {
    public let statusCode: Int
    
    public init(statusCode: Int) {
        self.statusCode = statusCode
    }
}

public final class JSONAPIService: APIService {
    private let baseURLFactory: () -> URL
    private let network: Networking
    private let requestInterceptors: [RequestInterceptor]
    private let responseInterceptors: [ResponseInterceptor]
    
    public init(
        baseURL: @autoclosure @escaping () -> URL,
        network: Networking,
        requestInterceptors: [RequestInterceptor] = [],
        responseInterceptors: [ResponseInterceptor] = []
    ) {
        self.baseURLFactory = baseURL
        self.network = network
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
    }
    
    public func request(_ originalRequest: URLRequest) async throws -> HTTPResponse {
        var request = originalRequest
        
        for interceptor in requestInterceptors {
            try await interceptor.intercept(
                service: self,
                request: &request
            )
        }
        
        var response = try await network.request(request)
        
        for interceptor in responseInterceptors {
            try await interceptor.intercept(
                service: self,
                response: &response
            )
        }
        
        if let code = response.statusCode, !response.isAccepted() {
            throw UnexpectedStatusCodeError(statusCode: code)
        }
        
        return response
    }
    
    public func request(
        url: URL,
        method: HTTPMethod,
        query: [String: String],
        headers: [String: String],
        body: RequestBody?
    ) async throws -> HTTPResponse {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        var queryItems = urlComponents?.queryItems ?? []
        query.forEach { key, value in
            queryItems.append(.init(name: key, value: value))
        }
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents?.url ?? url)
        request.httpMethod = method.rawValue
        request.httpBody = body?.data
        request.allHTTPHeaderFields = headers
        request.setValue(body?.contentType, forHTTPHeaderField: "Content-Type")
        
        return try await self.request(request)
    }
}
