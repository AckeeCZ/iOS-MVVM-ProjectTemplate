import AppCore
import Foundation

public protocol LoginViewModeling {
    var actions: LoginViewModelingActions { get }

    var username: String { get set }
    var password: String { get set }
}

public protocol LoginViewModelingActions {
    func login() async throws
}

public extension LoginViewModeling where Self: LoginViewModelingActions {
    var actions: LoginViewModelingActions { self }
}

public func createLoginVM(
    dependencies: HasUserManager
) -> LoginViewModeling {
    LoginViewModel(dependencies: dependencies)
}

final class LoginViewModel: LoginViewModeling, LoginViewModelingActions {
    var username = ""
    var password = ""

    private let userManager: UserManaging

    // MARK: - Initializers

    init(dependencies: HasUserManager) {
        userManager = dependencies.userManager
    }

    func login() async throws {
        try await userManager.actions.login(username: username, password: password)
    }
}
