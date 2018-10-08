import UIKit
import ReactiveSwift
import ReactiveCocoa

/// All objects (usually error objects) conforming to this protocol can be presented as error in responder chain
public protocol ErrorPresentable {
    var title: String? { get }
    var message: String { get }

    var detailedDescription: String? { get }
}

public extension ErrorPresentable {
    // make title optional
    var title: String? { return nil }
    var detailedDescription: String? { return "\(self)" }

    var debugString: String {
        return "Error at \(Date()), title:\(title ?? ""), message:\(message), instance: \(self)"
    }
}

// Make all NSErrors presentable
extension NSError: ErrorPresentable {
    public var message: String { return localizedDescription }
}

extension Reactive where Base: UIResponder {
    /** Binding target for presentable errors on all UIResponders. Typical usage is with UIViewController.
     
     reactive.errors() <~ viewModel.actions.fetchOrders.errors
     */
    public func errors<Error>() -> BindingTarget<Error> where Error: ErrorPresentable {
        return makeBindingTarget { (base, value) in
            base.displayError(value)
        }
    }
}

public extension UIResponder {
    func displayError(_ e: ErrorPresentable) {
        if (self as? ErrorPresenting)?.presentError(e) == true { // stop
            return
        } else {
            next?.displayError(e)
        }
    }
}

public protocol ErrorPresenting {
    func presentError(_ e: ErrorPresentable) -> Bool
}

// When no-one in responder chain is ErrorPresenting, window is the last object who can present the error.
// Shows simple alert with error title and message and OK button.
extension UIWindow: ErrorPresenting {
    public func presentError(_ e: ErrorPresentable) -> Bool {
        defer {
            logError(e)
        }
        guard let window = UIApplication.shared.keyWindow else { return false }
        let title = e.title ?? L10n.Basic.error

        let alertController = UIAlertController(title: title, message: e.message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: L10n.Basic.ok, style: .cancel, handler: { _ in alertController.dismiss(animated: true) })
        alertController.addAction(okAction)

        #if DEBUG || ADHOC
        let showMoreAction = UIAlertAction(title: L10n.Basic.showMore, style: .default, handler: { [weak self] _ in
            self?.presentErrorDetail(error: e)
        })
        alertController.addAction(showMoreAction)
        #endif

        window.rootViewController?.frontmostController.present(alertController, animated: true)
        return true
    }

    fileprivate func logError(_ e: ErrorPresentable) {
        print(e.debugString)
        // if you use any console or logger library, call it here...
    }

    fileprivate func presentErrorDetail(error: ErrorPresentable) {
//        let textView = UITextView()
//        textView.isEditable = false
//        textView.isSelectable = true
//        textView.textAlignment = .natural
//        textView.font = UIFont(name: "Courier New", size: 10)
//        textView.text = error.detailedDescription
//
//        let detailAlert = AlertController(title: "Error Detail", message: nil)
//        detailAlert.view.addSubview(textView)
//        textView.snp.makeConstraints{ make in
//            make.edges.equalToSuperview()
//            make.height.equalTo(300)
//        }
//
//        let detailOkAction = AlertController.Action(title: L10n.Basic.ok, style: .blue) {
//            detailAlert.dismiss(animated: true, completion: nil)
//        }
//        detailAlert.addAction(detailOkAction)
        guard let window = UIApplication.shared.keyWindow else { return }
        let alertContentController = AlertContentController(title: L10n.Basic.error, description: error.detailedDescription)
        if let baseVC = window.rootViewController?.frontmostController as? AlertPresenting {
            baseVC.present(popup: alertContentController)
        } else {
            window.rootViewController?.frontmostController.present(alertContentController, animated: true)
        }
    }
}

/// Visual style for error detail alert
//fileprivate let errorDetailAlertStyle: AlertVisualStyle = {
//    var style = AlertVisualStyle(alertStyle: .alert)
//    style.contentPadding = UIEdgeInsets(top: 36, left: 5, bottom: 5, right: 5)
//    style.width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)-20
//    return style
//}()
