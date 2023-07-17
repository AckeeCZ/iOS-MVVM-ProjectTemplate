import Foundation

public protocol UserManaging {
    var actions: UserManagingActions { get }
    
    var currentUserName: String? { get }
    var isLoggedIn: Bool { get }
}

public protocol UserManagingActions {
    func login(username: String, password: String) async throws
    func logout() async
}

public extension UserManaging where Self: UserManagingActions {
    var actions: UserManagingActions { self }
}

public protocol HasUserManager {
    var userManager: UserManaging { get }
}
