import UIKit
import ACKategories

/// Base class for all view controllers contained in app.
class BaseViewController: Base.ViewController, PopupPresenting {
    /// Presenting modal views
    lazy var popupAnimation = PopupModalAnimation()

    // MARK: View life cycle

    override func loadView() {
        super.loadView()

        view.backgroundColor = .white
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
