import Foundation
import ProjectDescription

public let projectName = "ProjectTemplate"
public let version: Version = "0.1.0"

public let codeCoverageTargets = projectTargets
public let projectTargets = [
    app,
    assets,
    core, coreTests,
    appUI, appUITests,
]
