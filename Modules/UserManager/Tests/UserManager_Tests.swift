@testable import UserManager
import XCTest

@MainActor
final class UserManager_Tests: XCTestCase {
    func test_login() async throws {
        let subject = UserManager()

        try await subject.login(username: "user", password: "password")

        XCTAssertEqual(subject.currentUser?.username, "user")
    }

    func test_loggedIn() async throws {
        let subject = UserManager()

        try await subject.login(username: "user", password: "password")

        XCTAssertTrue(subject.isLoggedIn)

        await subject.logout()

        XCTAssertFalse(subject.isLoggedIn)
    }

    func test_logout() async throws {
        let subject = UserManager()

        try await subject.login(username: "user", password: "password")
        await subject.logout()

        XCTAssertNil(subject.currentUser)
    }
}
