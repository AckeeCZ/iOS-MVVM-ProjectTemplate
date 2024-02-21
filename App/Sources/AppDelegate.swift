import FirebaseCrashlytics
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = .init(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.rootViewController?.view.backgroundColor = .red
        window?.makeKeyAndVisible()

        appDependencies.userManager.currentUserChanged = {
            Crashlytics.crashlytics().setUserID($0?.id)
            Crashlytics.crashlytics().setCustomValue($0?.username, forKey: "username")
        }

        return true
    }
}
