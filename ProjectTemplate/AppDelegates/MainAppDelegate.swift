import UIKit

/// Use as classic app delegate - for app flow and lifecycle handling, appearance settings etc.
final class MainAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // swiftlint:disable force_unwrapping
    private lazy var appFlowController = AppFlowController(window: window!)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        appFlowController.start()
        return true
    }
}
