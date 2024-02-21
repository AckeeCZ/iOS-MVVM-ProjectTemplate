import Core
import Foundation

public func createUserManager() -> UserManaging {
    UserManager()
}

final class UserManager: UserManaging, UserManagingActions {
    private(set) var currentUser: User?
    var currentUserChanged: (User?) -> () = { _ in }

    var isLoggedIn: Bool { currentUser != nil }

    func login(username: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000) // simulate network request
        currentUser = .init(id: UUID().uuidString, username: username)
        currentUserChanged(currentUser)
    }

    func logout() async {
        currentUser = nil
        currentUserChanged(currentUser)
    }
}
