import ProjectDescription

public extension DeploymentTarget {
    static let app = DeploymentTarget.iOS(
        targetVersion: "15.0",
        devices: [.iphone, .ipad]
    )
    static let tests = Self.app
}
