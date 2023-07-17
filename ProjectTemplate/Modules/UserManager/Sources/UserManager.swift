import Core

public func createUserManager() -> UserManaging {
    UserManager()
}

final class UserManager: UserManaging, UserManagingActions {
    private(set) var currentUserName: String?

    var isLoggedIn: Bool { currentUserName != nil }

    func login(username: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000) // simulate network request
        currentUserName = username
    }

    func logout() async {
        currentUserName = nil
    }
}
