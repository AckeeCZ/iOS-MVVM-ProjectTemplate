@testable import AckeeTemplate
import XCTest

@MainActor
final class APIService_Tests: XCTestCase {
    private var network: Network_Mock!
    
    // MARK: - Setup
    
    override func setUp() {
        network = .init()
        super.setUp()
    }
    
    // MARK: - Tests
    
    func test_request_path() async throws {
        var requestURL: URL?
        
        network.requestBody = { request in
            requestURL = request.url
            return .test()
        }
        
        let subject = APIService(
            baseURL: .ackeeCZ,
            network: network
        )
        
        _ = try await subject.request(.path("path1/path2"))
        
        XCTAssertEqual(
            "https://ackee.cz/path1/path2",
            requestURL?.absoluteString
        )
    }
    
    func test_request_allParams() async throws {
        var request: URLRequest?
        
        network.requestBody = {
            request = $0
            return .test()
        }
        
        let subject = APIService(
            baseURL: .ackeeCZ,
            network: network
        )
        
        _ = try await subject.request(
            .path("path1/path2"),
            method: .post,
            query: [
                "q1": "q1",
            ],
            headers: [
                "h1": "h1",
                "h2": "h2",
            ],
            body: .init(jsonDictionary: ["a": "b"], options: [])
        )
        
        XCTAssertEqual(
            "https://ackee.cz/path1/path2?q1=q1",
            request?.url?.absoluteString
        )
        XCTAssertEqual(
            request?.allHTTPHeaderFields,
            [
                "Content-Type": "application/json",
                "h1": "h1",
                "h2": "h2",
            ]
        )
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(request?.httpBody, #"{"a":"b"}"#.data(using: .utf8))
    }
}
