import XCTest
import Networking

@MainActor
final class OAuthInterceptor_Tests: XCTestCase {
    private final class MockAPIService: APIService {
        var requestBody: (URLRequest) async throws -> HTTPResponse = { _ in
            .init(request: nil, response: nil, data: nil)
        }
        
        func request(_ request: URLRequest) async throws -> HTTPResponse {
            try await requestBody(request)
        }
    }
    
    private final class UnexpectedCall: Error {
        init() { XCTFail("Should not be called") }
    }
    
    private var service: MockAPIService!
    
    // MARK: - Setup
    
    override func setUp() {
        service = .init()
        super.setUp()
    }
    
    // MARK: - Tests
    
    func test_notExpired() async throws {
        var response = HTTPResponse.test()
        let subject = OAuthInterceptor(
            isExpiredAuthDataResponse: { _ in false },
            requestUsedCurrentAuthData: { _ in .yes },
            refreshAuthData: { _ in throw UnexpectedCall() }
        )
        
        try await subject.intercept(service: service, response: &response)
    }
    
    func test_expired_checkCurrentAuthData() async throws {
        var response = HTTPResponse.test()
        var checkedCurrentAuthData = false
        let subject = OAuthInterceptor(
            isExpiredAuthDataResponse: { _ in true },
            requestUsedCurrentAuthData: { _ in
                checkedCurrentAuthData = true
                return .no(.test())
            },
            refreshAuthData: { _ in throw UnexpectedCall() }
        )
        
        try await subject.intercept(service: service, response: &response)
        
        XCTAssertTrue(checkedCurrentAuthData)
    }
    
    func test_refreshAuthData_ifCurrentAuthData() async throws {
        var response = HTTPResponse.test()
        var refreshedAuthData = false
        let subject = OAuthInterceptor(
            isExpiredAuthDataResponse: { _ in true },
            requestUsedCurrentAuthData: { _ in .yes },
            refreshAuthData: { _ in
                refreshedAuthData = true
                return .test()
            }
        )
        
        try await subject.intercept(service: service, response: &response)
        
        XCTAssertTrue(refreshedAuthData)
    }
    
    func test_retriesRequest_ifCurrentAuthData() async throws {
        var response = HTTPResponse.test(request: .init(url: .ackeeCZ))
        var refreshedAuthData = false
        var retriedRequest: URLRequest? = nil
        let refreshedRequest = URLRequest.test(url: .ackeeDE)
        
        let subject = OAuthInterceptor(
            isExpiredAuthDataResponse: { _ in true },
            requestUsedCurrentAuthData: { _ in .yes },
            refreshAuthData: { _ in
                refreshedAuthData = true
                return refreshedRequest
            }
        )
        
        service.requestBody = { request in
            retriedRequest = request
            return .test()
        }
        
        try await subject.intercept(service: service, response: &response)
        
        XCTAssertTrue(refreshedAuthData)
        XCTAssertEqual(retriedRequest, refreshedRequest)
    }
    
    func test_retriesRequest_ifNotCurrentAuthData() async throws {
        var response = HTTPResponse.test(request: .init(url: .ackeeCZ))
        var retriedRequest: URLRequest? = nil
        let refreshedRequest = URLRequest.test(url: .ackeeDE)
        
        let subject = OAuthInterceptor(
            isExpiredAuthDataResponse: { _ in true },
            requestUsedCurrentAuthData: { _ in .no(refreshedRequest) },
            refreshAuthData: { _ in throw UnexpectedCall() }
        )
        
        service.requestBody = { request in
            retriedRequest = request
            return .test()
        }
        
        try await subject.intercept(service: service, response: &response)
        
        XCTAssertEqual(retriedRequest, refreshedRequest)
    }
    
    func test_concurrentRefresh() async throws {
        var refreshCount = 0
        
        let refreshResponseRequest: (HTTPResponse) -> URLRequest = { response in
            var request = response.request!
            var headers = request.allHTTPHeaderFields!
            headers["refreshed"] = "true"
            request.allHTTPHeaderFields = headers
            return request
        }
        
        let subject = OAuthInterceptor(
            isExpiredAuthDataResponse: { response in
                let request = response.request!
                print("[IS_EXPIRED]", request.allHTTPHeaderFields!["index"]!, request.allHTTPHeaderFields!["refreshed"] ?? "false")
                return true
            },
            requestUsedCurrentAuthData: { response in
                guard response.request?.allHTTPHeaderFields?["index"] == "0" else {
                    return response.request?.allHTTPHeaderFields?["refreshed"] == "true" ? .yes : .no(refreshResponseRequest(response))
                }
                
                return .yes
            },
            refreshAuthData: { response in
                refreshCount += 1
                let request = try XCTUnwrap(response.request)
                print("[REFRESH]", request.allHTTPHeaderFields!["index"]!, request.allHTTPHeaderFields!["refreshed"] ?? "false")
                return refreshResponseRequest(response)
            }
        )
        
        service.requestBody = { request in
            print("[REQUEST][RETRY]", request.allHTTPHeaderFields!["index"]!, request.allHTTPHeaderFields!["refreshed"] ?? "false")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return .test()
        }
        
        let taskCount = Int.random(in: 10...300)
        let exp = expectation(description: "Refresh expectation")
        exp.expectedFulfillmentCount = taskCount
        
        for i in 0..<taskCount {
            var response = HTTPResponse.test(request: .test(headers: [
                "index": .init(i)
            ]))
            let request = try XCTUnwrap(response.request)
            print("[REQUEST][ORIG]", request.allHTTPHeaderFields!["index"]!, request.allHTTPHeaderFields!["refreshed"] ?? "false")
            
            Task {
                print("[INTERCEPT]", i)
                try await subject.intercept(service: service, response: &response)
                exp.fulfill()
            }
            try await Task.sleep(nanoseconds: 10)
        }
        
        await fulfillment(of: [exp])
        
        XCTAssertEqual(refreshCount, 1)
    }
}
