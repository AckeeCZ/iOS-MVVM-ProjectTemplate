import XCTest
@testable import Networking

@MainActor
final class OAuthInterceptor_Tests: XCTestCase {
    private final class UnexpectedCall: Error {
        init() { XCTFail("Should not be called") }
    }

    private var service: APIService_Mock!

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
            refreshAuthData: { throw UnexpectedCall() }
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
            refreshAuthData: { throw UnexpectedCall() }
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
            refreshAuthData: {
                refreshedAuthData = true
                return { _ in .test() }
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
            refreshAuthData: {
                refreshedAuthData = true
                return { _ in refreshedRequest }
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
            refreshAuthData: { throw UnexpectedCall() }
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
            var request = response.request
            var headers = request.allHTTPHeaderFields!
            headers["refreshed"] = "true"
            request.allHTTPHeaderFields = headers
            return request
        }

        let subject = OAuthInterceptor(
            isExpiredAuthDataResponse: { response in
                let request = response.request
                print("[IS_EXPIRED]", request.allHTTPHeaderFields!["index"]!, request.allHTTPHeaderFields!["refreshed"] ?? "false")
                return true
            },
            requestUsedCurrentAuthData: { response in
                guard response.request.allHTTPHeaderFields?["index"] == "0" else {
                    return response.request.allHTTPHeaderFields?["refreshed"] == "true" ? .yes : .no(refreshResponseRequest(response))
                }

                return .yes
            },
            refreshAuthData: {
                refreshCount += 1
                return { response in
                    let request = response.request
                    print("[REFRESH]", request.allHTTPHeaderFields!["index"]!, request.allHTTPHeaderFields!["refreshed"] ?? "false")
                    return refreshResponseRequest(response)
                }
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
    
    func test_concurrentRefresh_oldRequest() async throws {
        let authHeaderName = "Authorization"
        let originalToken = "Original"
        let newToken = "New"
        var currentToken = originalToken
        
        let subject = OAuthInterceptor(
            isExpiredAuthDataResponse: { $0.statusCode == 401 },
            requestUsedCurrentAuthData: {
                var request = $0.request
                
                let isCurrent = request.value(forHTTPHeaderField: authHeaderName) == currentToken
                
                if isCurrent {
                    return .yes
                }
                
                request.setValue(currentToken, forHTTPHeaderField: authHeaderName)
                
                return .no(request)
            },
            refreshAuthData: {
                if currentToken == newToken {
                    throw UnexpectedCall()
                }
                
                currentToken = newToken
                return {
                    var request = $0.request
                    request.setValue(currentToken, forHTTPHeaderField: authHeaderName)
                    return request
                }
            }
        )
        
        service.requestBody = { request in
            return try .test(
                request: request,
                response: .test(url: XCTUnwrap(request.url),
                statusCode: 200)
            )
        }
        
        let request1 = URLRequest.test(headers: [authHeaderName: currentToken])
        var response1 = try HTTPResponse.test(
            request: request1,
            response: .test(
                url: XCTUnwrap(request1.url),
                statusCode: 401
            )
        )
        let request2 = URLRequest.test(headers: [authHeaderName: currentToken])
        var response2 = try HTTPResponse.test(
            request: request2,
            response: .test(
                url: XCTUnwrap(request1.url),
                statusCode: 401
            )
        )
        
        try await subject.intercept(service: service, response: &response1)
        
        XCTAssertEqual(response1.request.value(forHTTPHeaderField: authHeaderName), newToken)
        
        try await subject.intercept(service: service, response: &response2)
        
        XCTAssertEqual(response2.request.value(forHTTPHeaderField: authHeaderName), newToken)
    }
}
