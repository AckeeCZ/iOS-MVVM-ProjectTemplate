import ACKategories
import Core
import Foundation
import UserManager

final class AppDependency: HasUserManager {
    let userManager = createUserManager()
    let versionUpdateManager = VersionUpdateManager(fetcher: FirebaseFetcher(key: "min_build_number"))
}

let appDependencies = AppDependency()
