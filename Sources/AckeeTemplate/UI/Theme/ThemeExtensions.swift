#if canImport(UIKit)
import UIKit

extension UIColor: ThemeProvider { }
#endif

#if canImport(UIKit) && !os(watchOS)
extension UIView: ThemeProvider { }
#endif
