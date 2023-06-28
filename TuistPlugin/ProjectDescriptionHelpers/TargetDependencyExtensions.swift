import ProjectDescription

public extension TargetDependency {
    /// XCFramework dependency built using Carthage
    static func carthage(_ name: String) -> TargetDependency {
        let name = name.hasSuffix(".xcframework") ? name : name + ".xcframework"
        return .xcframework(path: .relativeToRoot("Carthage/Build/" + name))
    }
    
    /// Shortcut for StoreKit dependency
    static var storeKit: TargetDependency {
        .sdk(name: "StoreKit", type: .framework, status: .required)
    }
}
