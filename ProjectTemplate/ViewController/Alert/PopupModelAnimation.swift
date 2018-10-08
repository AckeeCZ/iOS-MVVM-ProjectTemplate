//
//  PopupModelAnimation.swift
//  ProjectTemplate
//
//  Created by Marek Fořt on 10/5/18.
//

import Foundation
import UIKit

final class PopupModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    enum AnimationType {
        case present
        case dismiss
    }

    var animationType: AnimationType = .present

    lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x174B71)
        return view
    }()

    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        //The view controller's view that is presenting the modal view
        let containerView = transitionContext.containerView

        if animationType == .present {
            //The modal view itself
            guard let modalView = (transitionContext.viewController(forKey: .to)?.view) else { return }

            coverView.alpha = 0
            containerView.addSubview(coverView)
            containerView.snp.makeConstraints({ (make) in
                make.edges.equalTo(0)
            })
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            coverView.frame = containerView.frame

            containerView.addSubview(modalView)
            modalView.snp.makeConstraints({ (make) in
                make.leading.trailing.equalTo(containerView).inset(19)
                make.height.lessThanOrEqualTo(containerView.snp.height).multipliedBy(0.85)
                make.center.equalTo(containerView)
            })
            modalView.layer.contentsScale = UIScreen.main.scale
            modalView.layer.shadowColor = UIColor.black.cgColor
            modalView.layer.shadowOffset = CGSize.zero
            modalView.layer.shadowRadius = 5.0
            modalView.layer.shadowOpacity = 0.5
            modalView.layer.masksToBounds = false
            modalView.clipsToBounds = false

            let endFrame = modalView.frame
            modalView.frame = CGRect(x: endFrame.origin.x, y: containerView.frame.size.height, width: endFrame.size.width, height: endFrame.size.height)
            containerView.bringSubviewToFront(modalView)

            //Move off of the screen so we can slide it up
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: { [weak self] in
                modalView.frame = endFrame
                self?.coverView.alpha = 0.65

                }, completion: { (finished) in
                    transitionContext.completeTransition(true)
            })

        } else if (animationType == .dismiss) {

            let modalView = transitionContext.viewController(forKey: .from)?.view
            //The modal view itself
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { [weak self] in
                var frame = modalView!.frame
                frame.origin.y = containerView.frame.height
                modalView!.layer.transform = CATransform3DRotate(modalView!.layer.transform, (3.14/180) * 35, 1, 0.0, 0.0)
                self?.coverView.alpha = 0

                modalView!.frame = frame
                }, completion: { (completed) in
                    self.coverView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })

        }
    }

    @objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (self.animationType == .present) ? 1.0 : 0.3
    }
}

