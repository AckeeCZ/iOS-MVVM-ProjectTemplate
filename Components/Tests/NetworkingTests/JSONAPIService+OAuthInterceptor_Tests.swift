@testable import Networking
import XCTest

@MainActor
final class JSONAPIService_OAuthInterceptor_IntegrationTests: XCTestCase {
    private var network: Network_Mock!
    
    // MARK: - Setup
    
    override func setUp() {
        network = .init()
        super.setUp()
    }
    
    // MARK: - Tests
    
    func test_expiredTokenRefresh() async throws {
        let originalToken = "abc"
        let newToken = "def"
        let authHeaderName = "Authorization"
        var currentToken = originalToken
        
        let refreshResponseRequest: (HTTPResponse) -> URLRequest = { response in
            var request = response.request
            request.setValue(currentToken, forHTTPHeaderField: authHeaderName)
            return request
        }
        
        let oauth = OAuthInterceptor(
            isExpiredAuthDataResponse: { $0.statusCode == 401 },
            requestUsedCurrentAuthData: {
                let isCurrent = $0.request.value(forHTTPHeaderField: authHeaderName) == currentToken
                guard !isCurrent else {
                    return .yes
                }
                
                return .no(refreshResponseRequest($0))
            },
            refreshAuthData: {
                currentToken = newToken
                
                self.network.requestBody = {
                    .test(
                        request: $0,
                        response: .init(
                            url: try XCTUnwrap($0.url),
                            statusCode: 200,
                            httpVersion: nil,
                            headerFields: nil
                        )
                    )
                }
                
                return refreshResponseRequest
            }
        )
        let apiService = JSONAPIService(
            baseURL: .ackeeCZ,
            network: network,
            responseInterceptors: [oauth]
        )
        
        network.requestBody = {
            .test(
                request: $0,
                response: .init(
                    url: try XCTUnwrap($0.url),
                    statusCode: 401,
                    httpVersion: nil,
                    headerFields: nil
                )
            )
        }
        
        let response = try await apiService.request(.test(
            url: .ackeeCZ,
            headers: ["Authorization": originalToken]
        ))
        
        XCTAssertEqual(newToken, response.request.value(forHTTPHeaderField: authHeaderName))
    }
    
    func test_expiredTokenRefresh_concurrent() async throws {
        let originalToken = "abc"
        let newToken = "def"
        let authHeaderName = "Authorization"
        let taskHeaderName = "Task"
        var currentToken = originalToken
        var refreshCount = 0
        var retriedRequests = [URLRequest]()
        
        let refreshResponseRequest: (HTTPResponse) -> URLRequest = { response in
            var request = response.request
            request.setValue(currentToken, forHTTPHeaderField: authHeaderName)
            return request
        }
        
        let oauth = OAuthInterceptor(
            isExpiredAuthDataResponse: { $0.statusCode == 401 },
            requestUsedCurrentAuthData: {
                let isCurrent = $0.request.value(forHTTPHeaderField: authHeaderName) == currentToken
                guard !isCurrent else {
                    return .yes
                }
                
                return .no(refreshResponseRequest($0))
            },
            refreshAuthData: {
                refreshCount += 1
                currentToken = newToken
                
                self.network.requestBody = {
                    try await Task.sleep(nanoseconds: 1_000_000)
                    retriedRequests.append($0)
                    return .test(
                        request: $0,
                        response: .init(
                            url: try XCTUnwrap($0.url),
                            statusCode: 200,
                            httpVersion: nil,
                            headerFields: nil
                        )
                    )
                }
                
                return refreshResponseRequest
            }
        )
        let apiService = JSONAPIService(
            baseURL: .ackeeCZ,
            network: network,
            responseInterceptors: [oauth]
        )
        
        network.requestBody = {
            .test(
                request: $0,
                response: .init(
                    url: try XCTUnwrap($0.url),
                    statusCode: 401,
                    httpVersion: nil,
                    headerFields: nil
                )
            )
        }
        
        let taskCount = Int.random(in: 10...300)
        let exp = expectation(description: "Refresh expectation")
        exp.expectedFulfillmentCount = taskCount
        
        for i in 0..<taskCount {
            Task {
                let response = try await apiService.request(.test(
                    url: .ackeeCZ,
                    headers: [
                        authHeaderName: originalToken,
                        taskHeaderName: .init(i),
                    ]
                ))
                XCTAssertEqual(newToken, response.request.value(forHTTPHeaderField: authHeaderName))
                
                exp.fulfill()
            }
        }
        
        await fulfillment(of: [exp])
        
        XCTAssertEqual(1, refreshCount)
        XCTAssertEqual(
            .init(0..<taskCount),
            retriedRequests.compactMap { $0.value(forHTTPHeaderField: taskHeaderName).flatMap(Int.init) }.sorted()
        )
    }
}
