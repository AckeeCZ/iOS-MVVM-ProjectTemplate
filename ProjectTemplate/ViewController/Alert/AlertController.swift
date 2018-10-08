//
//  AlertController.swift
//  ProjectTemplate
//
//  Created by Marek Fořt on 10/5/18.
//

import UIKit

final class AlertController: UIViewController, AlertPresenting {
    struct Action {
        enum Style {
            case blue
            case text
        }

        static var ok: Action { return Action(title: L10n.Basic.ok, style: .blue) }
        static var cancel: Action { return Action(title: L10n.Basic.showMore, style: .text) }

        let title: String
        let style: Style
        let action: () -> ()
    }

    lazy var popupAnimation = PopupModalAnimation()

    private let _title: String
    private let _message: String
    private var actions = [Action]() {
        didSet {
            updateActionButtons()
        }
    }

    private weak var actionVStack: UIStackView!

    // MARK: Initializers

    init(title: String, message: String?) {
        assert(title.count > 0, "Title cannot be empty")

        self._title = title
        self._message = message ?? ""
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View life cycle

    override func loadView() {
        super.loadView()

        let rate = UIScreen.main.graphicRate

        view.backgroundColor = .white
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true

        let titleLabel = UILabel()
        titleLabel.font = UIFont.theme.bold(25)
        titleLabel.numberOfLines = 0
        titleLabel.text = _title
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(45 * rate.height)
            make.leading.trailing.equalToSuperview().inset(26)
        }

        var lastView: UIView = titleLabel

        if _message.count > 0 {
            let messageLabel = UILabel()
            messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            messageLabel.numberOfLines = 0
            messageLabel.text = _message
            messageLabel.textAlignment = .center
            view.addSubview(messageLabel)
            messageLabel.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalTo(titleLabel.snp.bottom).offset(13)
            }

            lastView = messageLabel
        }

        let actionVStack = UIStackView()
        actionVStack.spacing = 23
        actionVStack.axis = .vertical
        view.addSubview(actionVStack)
        actionVStack.snp.makeConstraints { (make) in
            make.top.equalTo(lastView.snp.bottom).offset(42 * rate.height)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(27 * rate.height)
        }
        self.actionVStack = actionVStack
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateActionButtons()
    }

    // MARK: Public interface

    func addAction(_ action: Action) {
        actions.append(action)
    }

    // MARK: Private helpers

    private func updateActionButtons() {
        guard isViewLoaded else { return }

        actionVStack.removeAllArrangedSubviews()

        actions.forEach { action in
            let button = self.button(forAction: action)
            actionVStack.addArrangedSubview(button)
        }
    }

    private func button(forAction action: Action) -> UIControl {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitle(action.title, for: .normal)
        button.on(.touchUpInside) { [weak self] _ in
            action.action()
            self?.dismiss(animated: true)
        }
        return button
    }
}

extension AlertController.Action {
    init(title: String, style: Style) {
        self.init(title: title, style: style, action: { })
    }
}

extension AlertController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        popupAnimation.animationType = .present
        return popupAnimation
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        popupAnimation.animationType = .dismiss
        return popupAnimation
    }
}

extension UIScreen {
    struct GraphicRate {
        let width: CGFloat
        let height: CGFloat
    }

    var graphicRate: GraphicRate {
        return GraphicRate(width: bounds.width / 375, height: bounds.height / 667)
    }

    var isExtraCompact: Bool {
        return graphicRate.width < 1 && graphicRate.height < 1
    }
}
