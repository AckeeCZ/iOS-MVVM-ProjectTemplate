import Foundation

final class UserManager_Mock: UserManaging, UserManagingActions {
    var currentUserName: String? = nil
    var isLoggedIn: Bool = false
    
    var loginBody: (String, String) async throws -> () = { _, _ in }
    
    func login(username: String, password: String) async throws {
        try await loginBody(username, password)
    }
    
    var logoutBody: () async -> () = { }
    
    func logout() async {
        await logoutBody()
    }
}
