import AckeeTemplate
import ProjectDescription

public extension TargetDependency {
    static let ackategories = TargetDependency.carthage("ACKategories")
}

public extension [TargetDependency] {
    static let firebase: Self = [
        .carthage("FBLPromises"),
        .carthage("FirebaseABTesting"),
        .carthage("FirebaseAnalytics"),
        .carthage("FirebaseCore"),
        .carthage("FirebaseCoreExtension"),
        .carthage("FirebaseCoreInternal"),
        .carthage("FirebaseCrashlytics"),
        .carthage("FirebaseInstallations"),
        .carthage("FirebaseRemoteConfig"),
        .carthage("FirebaseSessions"),
        .carthage("FirebaseSharedSwift"),
        .carthage("GoogleAppMeasurement"),
        .carthage("GoogleAppMeasurementIdentitySupport"),
        .carthage("GoogleDataTransport"),
        .carthage("GoogleUtilities"),
        .carthage("Networking"),
        .carthage("PromisesSwift"),
        .carthage("PushNotifications"),
        .carthage("nanopb"),
    ]
}
