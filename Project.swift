import ProjectDescription
import ProjectDescriptionHelpers

let firebaseDependencies: [TargetDependency] = [
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

let project = Project.project(
    name: "ProjectTemplate",
    projectVersion: Version(0, 1, 0),
    platform: .iOS,
    dependencies: [
        .carthage(name: "ACKategories"),
        .carthage(name: "ReactiveCocoa"),
        .carthage(name: "ReactiveSwift"),
        .carthage(name: "Reqres"),
        .carthage(name: "SnapKit"),
    ] + firebaseDependencies
)
