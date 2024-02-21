import AckeeTemplate
import ProjectDescription

public extension TargetDependency {
// In real project you will want the following line
//    static let ackategories = TargetDependency.carthage("ACKategories")
    static let ackategories = TargetDependency.xcframework(path: "../Carthage/Build/ACKategories.xcframework")
}
