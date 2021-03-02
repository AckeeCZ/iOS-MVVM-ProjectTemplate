import ProjectDescription

public extension TargetAction {
    static func crashlytics() -> TargetAction {
        .post(
            path: "BuildPhases/Crashlytics.sh",
            name: "Crashlytics",
            basedOnDependencyAnalysis: false
        )
    }
    
    static func swiftlint() -> TargetAction {
        .pre(
            script: "mint run swiftlint autocorrect; mint run swiftlint",
            name: "Swiftlint",
            basedOnDependencyAnalysis: false
        )
    }
}
