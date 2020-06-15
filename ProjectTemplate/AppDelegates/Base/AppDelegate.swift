import UIKit

/// Main app delegate class forwarding callbacks on registered delegates
final class AppDelegate: PluggableApplicationDelegate {

    // swiftlint:disable weak_delegate
    private let mainDelegate = MainAppDelegate()

    override var window: UIWindow? {
        get { mainDelegate.window }
        set { mainDelegate.window = newValue }
    }

    override var delegates: [UIApplicationDelegate] {
        [
            FirebaseAppDelegate(),
            mainDelegate
        ]
    }
}
