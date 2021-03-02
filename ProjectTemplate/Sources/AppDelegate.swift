import UIKit
import ACKategories
import FirebaseCore

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private lazy var appFlowCoordinator = AppFlowCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // TODO: Uncomment this line when your Google plists are ready!
        // FirebaseApp.configure()

        // Clear launch screen cache on app launch (debug and beta configurations only)
        #if DEBUG || ADHOC
        application.clearLaunchScreenCache()
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        // swiftlint:disable force_unwrapping
        appFlowCoordinator.start(in: window!)
        return true
    }
}
