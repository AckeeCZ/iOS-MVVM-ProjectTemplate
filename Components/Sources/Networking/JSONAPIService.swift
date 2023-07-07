import Foundation

public protocol RequestInterceptor {
    func intercept(request: inout URLRequest)
}

public protocol ResponseInterceptor {
    func intercept(response: inout HTTPResponse)
}

public protocol DecodingInterceptor {
    func intercept<T: Decodable>(response: HTTPResponse, result: Result<T, DecodingError>)
}

public final class JSONAPIService {
    private let baseURLFactory: () -> URL
    private let network: Networking
    private let requestInterceptors: [RequestInterceptor]
    private let responseInterceptors: [ResponseInterceptor]
    private let decodingInterceptors: [DecodingInterceptor]
    
    init(
        baseURL: @autoclosure @escaping () -> URL,
        network: Networking,
        requestInterceptors: [RequestInterceptor] = [],
        responseInterceptors: [ResponseInterceptor] = [],
        decodingInterceptors: [DecodingInterceptor] = []
    ) {
        self.baseURLFactory = baseURL
        self.network = network
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
        self.decodingInterceptors = decodingInterceptors
    }
    
    public func request(
        url: URL,
        method: HTTPMethod,
        query: [String : String],
        headers: [String : String],
        body: RequestBody?
    ) -> Async<HTTPResponse> {
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
        
        requestInterceptors.forEach { interceptor in
            interceptor.intercept(request: &request)
        }
        
        return network.request(request)
            .map { [responseInterceptors] response in
                var response = response
                responseInterceptors.forEach { interceptor in
                    interceptor.intercept(response: &response)
                }
                return response
            }
    }
    
    public func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        query: [String : String],
        headers: [String : String],
        body: RequestBody?,
        decoder: JSONDecoder,
        result: T.Type = T.self
    ) -> Async<T> {
        request(
            url: url,
            method: method,
            query: query,
            headers: headers,
            body: body
        )
        .attemptMap { [decodingInterceptors] response in
            do {
                let result = try decoder.decode(result, from: response.data ?? .init())
                decodingInterceptors.forEach { interceptor in
                    interceptor.intercept(response: response, result: .success(result))
                }
                return result
            } catch let error as DecodingError {
                decodingInterceptors.forEach { interceptor in
                    interceptor.intercept(
                        response: response,
                        result: Result<T, DecodingError>.failure(error)
                    )
                }
                throw error
            }
        }
    }
}
