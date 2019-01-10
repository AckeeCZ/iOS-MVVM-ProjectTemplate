import UIKit
import os.log

/// Base class for all view controllers contained in app.
class BaseViewController: UIViewController, PopupPresenting {

    static var logEnabled: Bool = true

    /// Presenting modal views
    lazy var popupAnimation = PopupModalAnimation()

    /// Navigation bar is shown/hidden in viewWillAppear according to this flag
    var hasNavigationBar: Bool = true

    private var firstWillAppearOccured = false
    private var firstDidAppearOccured = false

    // MARK: Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

        if BaseViewController.logEnabled {
            os_log("📱 👶 %@", log: Logger.lifecycleLog(), type: .info, self)
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

        if !firstWillAppearOccured {
            viewWillFirstAppear(animated)
            firstWillAppearOccured = true
        }

        navigationController?.setNavigationBarHidden(!hasNavigationBar, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !firstDidAppearOccured {
            viewDidFirstAppear(animated)
            firstDidAppearOccured = true
        }
    }

    /// Method is called when `viewWillAppear(_:)` is called for the first time
    func viewWillFirstAppear(_ animated: Bool) {

    }

    /// Method is called when `viewDidAppear(_:)` is called for the first time
    func viewDidFirstAppear(_ animated: Bool) {

    }

    deinit {
        if BaseViewController.logEnabled {
            os_log("📱 ⚰️ %@", log: Logger.lifecycleLog(), type: .info, self)
        }
    }
}

extension BaseViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        popupAnimation.animationType = .present
        return popupAnimation
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        popupAnimation.animationType = .dismiss
        return popupAnimation
    }
}
