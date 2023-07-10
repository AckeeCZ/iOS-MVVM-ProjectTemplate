import UIKit

public protocol PopupPresenting {
    var popupAnimation: PopupModalAnimation { get }

    func present(popup: UIViewController)
}

public extension PopupPresenting where Self: UIViewController {
    /// Presents popup with animation
    func present(popup: UIViewController, animated: Bool) {
        popup.transitioningDelegate = popupAnimation
        popup.modalPresentationStyle = .custom
        present(popup, animated: animated)
    }
}

