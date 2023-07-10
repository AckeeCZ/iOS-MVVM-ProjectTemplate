import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = .init(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.rootViewController?.view.backgroundColor = .red
        window?.makeKeyAndVisible()
        
        return true
    }
}
