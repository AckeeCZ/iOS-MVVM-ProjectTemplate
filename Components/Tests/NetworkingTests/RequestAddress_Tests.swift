import Networking
import XCTest

final class RequestAddress_Tests: XCTestCase {
    func test_pathInit() {
        let subject: RequestAddress = "path1/path2"
        XCTAssertEqual(subject, .path("path1/path2"))
    }
    
    func test_urlInit() throws {
        let subject: RequestAddress = "https://ackee.cz/path1/path2"
        XCTAssertEqual(
            subject,
            .url(.init(string: "https://ackee.cz/path1/path2")!)
        )
    }
}
