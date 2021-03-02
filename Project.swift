import ProjectDescription
import ProjectDescriptionHelpers

private let firebaseDependencies: [TargetDependency] = [
    .carthage(name: "FIRAnalyticsConnector"),
    .carthage(name: "FirebaseABTesting"),
    .carthage(name: "FirebaseAnalytics"),
    .carthage(name: "FirebaseCore"),
    .carthage(name: "FirebaseCoreDiagnostics"),
    .carthage(name: "FirebaseCrashlytics"),
    .carthage(name: "FirebaseInstallations"),
    .carthage(name: "FirebaseInstanceID"),
    .carthage(name: "FirebaseMessaging"),
    .carthage(name: "FirebasePerformance"),
    .carthage(name: "FirebaseRemoteConfig"),
    .carthage(name: "GoogleAppMeasurement"),
    .carthage(name: "GoogleDataTransport"),
    .carthage(name: "GoogleUtilities"),
    .carthage(name: "nanopb"),
    .carthage(name: "PromisesObjC"),
    .carthage(name: "Protobuf"),
]

private let name = "ProjectTemplate"
private let version = Version(0, 1, 0)
private let configInfo = configurationInfo()

private let app = Target.app(
    name: name,
    platform: .iOS,
    infoPlist: .default,
    dependencies: [
        .carthage(name: "ACKategories"),
        .carthage(name: "ReactiveCocoa"),
        .carthage(name: "ReactiveSwift"),
        .carthage(name: "Reqres"),
        .carthage(name: "SnapKit"),
    ] + firebaseDependencies,
    settings: Settings(base: configInfo.settingsDictionary(name: name))
)

let project = Project(
    name: name,
    settings: Settings(
        base: SettingsDictionary.base.addingProjectVersion(version),
        configurations: [configInfo.configuration]
    ),
    targets: [
        app,
        .unitTests(for: app),
    ]
)
