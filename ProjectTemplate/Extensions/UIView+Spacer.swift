import UIKit
import SnapKit
import ReactiveSwift

extension UIView {
    private func createSpacer(_ size: CGFloat, axis: NSLayoutConstraint.Axis, priority: Int) -> UIView {
        let v = UIView()
        v.isHidden = isHidden
        v.reactive.isHidden <~ reactive.signal(forKeyPath: "hidden").compactMap { $0 as? Bool }
        v.snp.makeConstraints { make in
            switch axis {
            case .vertical: make.height.equalTo(size).priority(priority)
            case .horizontal: make.width.equalTo(size).priority(priority)
            @unknown default: assertionFailure("Unknown axis \(axis)")
            }
        }
        return v
    }

    /// Create vertical spacer whose `isHidden` is tied to `self.isHidden`
    func createVSpacer(_ height: CGFloat, priority: Int = 999) -> UIView {
        createSpacer(height, axis: .vertical, priority: priority)
    }

    /// Create horizontal spacer whose `isHidden` is tied to `self.isHidden`
    func createHSpacer(_ width: CGFloat, priority: Int = 999) -> UIView {
        createSpacer(width, axis: .horizontal, priority: priority)
    }
}
