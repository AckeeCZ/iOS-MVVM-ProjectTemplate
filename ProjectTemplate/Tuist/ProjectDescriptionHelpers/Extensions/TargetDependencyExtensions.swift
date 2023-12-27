import AckeeTemplate
import ProjectDescription

public extension TargetDependency {
// In real project you will want the following line
//    static let ackeeTemplate = TargetDependency.carthage("AckeeTemplate")
    static let ackeeTemplate = TargetDependency.xcframework(path: "../Carthage/Build/AckeeTemplate.xcframework")
}
