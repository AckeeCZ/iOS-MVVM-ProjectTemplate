import UIKit

/// Base class for all view controllers contained in app.
class BaseViewController: UIViewController {

    static var logEnabled: Bool = true

    /// Navigation bar is shown/hidden in viewWillAppear according to this flag
    var hasNavigationBar: Bool = true

    // MARK: Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

        if BaseViewController.logEnabled {
            NSLog("📱 👶 \(self)")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: View life cycle

    override func loadView() {
        super.loadView()

        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(!hasNavigationBar, animated: animated)
    }

    deinit {
        if BaseViewController.logEnabled {
            NSLog("📱 ⚰️ \(self)")
        }
    }
}
