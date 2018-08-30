import UIKit
import ReactiveSwift
import ReactiveCocoa

/// All objects (usually error objects) conforming to this protocol can be presented as error in responder chain
public protocol ErrorPresentable {
    var title: String? { get }
    var message: String { get }
}

public extension ErrorPresentable {
    // make title optional
    var title: String? { return nil }

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

/// When no-one in responder chain is ErrorPresenting, window is the last object who can present the error.
/// Shows simple alert with error title and message and OK button.
extension UIWindow: ErrorPresenting {
    public func presentError(_ e: ErrorPresentable) -> Bool {
        defer {
            logError(e)
        }
        guard let window = UIApplication.shared.keyWindow else { return false }
        let title = e.title ?? L10n.Basic.error
        let alertController = UIAlertController(title: title, message: e.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.Basic.ok, style: .cancel) { _ in }
        alertController.addAction(okAction)

        #if DEBUG
            let showMoreAction = UIAlertAction(title: L10n.Basic.showMore, style: .default) { _ in
                let detailAlert = UIAlertController(title: "Error Detail", message: "\(e)", preferredStyle: .alert)
                let detailOkAction = UIAlertAction(title: L10n.Basic.ok, style: .cancel) { _ in }
                detailAlert.addAction(detailOkAction)
                window.rootViewController?.frontmostController.present(detailAlert, animated: true)
            }
            alertController.addAction(showMoreAction)
        #endif

        window.rootViewController?.frontmostController.present(alertController, animated: true)
        return true
    }

    fileprivate func logError(_ e: ErrorPresentable) {
        print(e.debugString)
        // if you use any console or logger library, call it here...
    }
}

