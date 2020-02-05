import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "SysRoot", platform: .iOS, dependencies: [
    .project(target: "SysRootKit", path: .relativeToManifest("../SysRootKit")),
    .cocoapods(path: "."),
    .framework(path: Path("Carthage/Build/iOS/ACKategories.framework")),
    .framework(path: Path("Carthage/Build/iOS/SnapKit.framework")),
    .framework(path: Path("Carthage/Build/iOS/Reqres.framework"))
])