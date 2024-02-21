import Core
import Foundation

public protocol ProfileViewModeling {
    var actions: ProfileViewModelingActions { get }

    var username: String { get }
}

public protocol ProfileViewModelingActions {
    func logout() async
}

public extension ProfileViewModeling where Self: ProfileViewModelingActions {
    var actions: ProfileViewModelingActions { self }
}

public func createProfileVM(
    dependencies: HasUserManager
) -> ProfileViewModeling {
    ProfileViewModel(dependencies: dependencies)
}

final class ProfileViewModel: ProfileViewModeling, ProfileViewModelingActions {
    let username: String

    private let userManager: UserManaging

    // MARK: - Initializers

    init(dependencies: HasUserManager) {
        userManager = dependencies.userManager
        username = userManager.currentUser?.username ?? ""
    }

    func logout() async {
        await userManager.actions.logout()
    }
}
