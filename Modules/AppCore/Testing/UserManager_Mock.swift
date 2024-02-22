import Foundation

final class UserManager_Mock: UserManaging, UserManagingActions {
    var currentUser: User?
    var currentUserChanged: (User?) -> () = { _ in }
    var isLoggedIn: Bool = false

    var loginBody: (String, String) async throws -> Void = { _, _ in }

    func login(username: String, password: String) async throws {
        try await loginBody(username, password)
    }

    var logoutBody: () async -> Void = { }

    func logout() async {
        await logoutBody()
    }
}
