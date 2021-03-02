import ProjectDescription

public extension TargetDependency {
    static func carthage(name: String, platform: Platform = .iOS) -> TargetDependency {
        .framework(path: "Carthage/Build/\(platform.rawValue)/\(name).framework")
    }
}
