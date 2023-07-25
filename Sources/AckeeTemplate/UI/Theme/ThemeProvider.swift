import Foundation

public struct Theme<Base> { }

public protocol ThemeProvider { }

public extension ThemeProvider {
    static var theme: Theme<Self>.Type { Theme<Self>.self }

    var theme: Theme<Self> { Theme<Self>() } // theoretically unneccessary allocation overhead every call, but SnapKit uses the same pattern so...
}
