import Foundation

public struct User: Identifiable {
    public let id: String
    public let username: String

    public init(id: String, username: String) {
        self.id = id
        self.username = username
    }
}

public protocol UserManaging: AnyObject {
    var actions: UserManagingActions { get }

    var currentUser: User? { get }
    var isLoggedIn: Bool { get }

    var currentUserChanged: (User?) -> () { get set }
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
