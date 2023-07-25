#if canImport(UIKit) && !os(watchOS)
import Foundation
import UIKit

/// Animation for presenting popups
public final class PopupModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    /// Popup horizontal inset
    public var popupXInset: CGFloat = 19

    /// Background color for popup view
    public var popupBackgroundColor: UIColor = .clear

    /// Background color for
    public var backgroundColor: UIColor = .clear

    /// Visual effect for background view
    public var visualEffect: UIVisualEffect? = UIBlurEffect(style: .light)

    /// Final alpha for background view
    public var finalAlpha: CGFloat = 1.0

    /// Duration of presenting modal
    public var presentDuration: TimeInterval = 1.0

    /// Duration of dismissing modal
    public var dismissDuration: TimeInterval = 0.3

    /// Shadow offset
    public var shadowOffset: CGSize = CGSize.zero

    /// Shadow color
    public var shadowColor: CGColor = UIColor.black.cgColor

    /// Shadow radius
    public var shadowRadius: CGFloat = 5.0

    /// Shadow opacity
    public var shadowOpacity: Float = 0.5

    /// Popup animation damping
    public var animationDamping: CGFloat = 0.8

    /// Initial animation spring velocity
    public var animationInitialSpringVelocity: CGFloat = 1

    public enum AnimationType {
        case present
        case dismiss
    }

    public var animationType: AnimationType = .present

    private lazy var coverView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = visualEffect
        view.backgroundColor = popupBackgroundColor
        return view
    }()

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        //The view controller's view that is presenting the modal view
        let containerView = transitionContext.containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false

        if animationType == .present {
            //The modal view itself
            guard let modalView = transitionContext.viewController(forKey: .to)?.view, let containerParent = containerView.superview else { return }
            
            modalView.translatesAutoresizingMaskIntoConstraints = false

            coverView.alpha = 0
            containerView.addSubview(coverView)
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: containerParent.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: containerParent.trailingAnchor),
                containerView.topAnchor.constraint(equalTo: containerParent.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: containerParent.bottomAnchor),
            ])
            containerView.backgroundColor = backgroundColor
            coverView.frame = containerView.frame

            containerView.addSubview(modalView)
            NSLayoutConstraint.activate([
                modalView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: popupXInset),
                modalView.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor, multiplier: 0.85),
                modalView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                modalView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ])
            modalView.layer.contentsScale = UIScreen.main.scale
            modalView.layer.shadowColor = shadowColor
            modalView.layer.shadowOffset = shadowOffset
            modalView.layer.shadowRadius = shadowRadius
            modalView.layer.shadowOpacity = shadowOpacity
            modalView.layer.masksToBounds = false
            modalView.clipsToBounds = false

            let endFrame = modalView.frame
            modalView.frame = CGRect(x: endFrame.origin.x, y: containerView.frame.size.height, width: endFrame.size.width, height: endFrame.size.height)
            containerView.bringSubviewToFront(modalView)

            //Move off of the screen so we can slide it up
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: animationDamping, initialSpringVelocity: animationInitialSpringVelocity, options: .curveLinear, animations: {
                modalView.frame = endFrame
                self.coverView.alpha = self.finalAlpha
                self.coverView.effect = self.visualEffect
                }, completion: { _ in
                    transitionContext.completeTransition(true)
            })

        } else if animationType == .dismiss {
            guard let modalView = transitionContext.viewController(forKey: .from)?.view else { return }
            //The modal view itself
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                var frame = modalView.frame
                frame.origin.y = containerView.frame.height
                modalView.layer.transform = CATransform3DRotate(modalView.layer.transform, (3.14/180) * 35, 1, 0.0, 0.0)
                self.coverView.alpha = 0
                self.coverView.effect = nil

                modalView.frame = frame
            }, completion: { _ in
                    self.coverView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })

        }
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationType == .present ? presentDuration : dismissDuration
    }
}

extension PopupModalAnimation: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationType = .present
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationType = .dismiss
        return self
    }
}
#endif
