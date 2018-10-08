//
//  AlertPresenting.swift
//  ProjectTemplate
//
//  Created by Marek Fořt on 10/5/18.
//

import UIKit

protocol AlertPresenting: UIViewControllerTransitioningDelegate {
    var popupAnimation: PopupModalAnimation { get }

    func present(popup: UIViewController)
}

extension AlertPresenting where Self: UIViewController {
    func present(popup: UIViewController) {
        popup.transitioningDelegate = self
        popup.modalPresentationStyle = .custom
        present(popup, animated: true)
    }
}

