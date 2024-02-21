import Core
import Foundation
import UserManager

final class AppDependency: HasUserManager {
    let userManager = createUserManager()
}

let appDependencies = AppDependency()
