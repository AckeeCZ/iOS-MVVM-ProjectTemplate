import FirebaseMessaging
import ReactiveSwift

protocol HasFirebasePushObserver {
    var firebasePushObserver: FirebasePushObserving { get }
}

protocol FirebasePushObserving {
    func start()
}

final class FirebasePushObserver: FirebasePushObserving {
    typealias Dependencies = HasPushManager

    private let pushManager: PushManaging

    // MARK: Initializers

    init(dependencies: Dependencies) {
        pushManager = dependencies.pushManager
    }

    // MARK: Public interface

    func start() {
        pushManager.actions.registerToken <~ NotificationCenter.default.reactive
            .notifications(forName: .InstanceIDTokenRefresh)
            .map { _ in Messaging.messaging().fcmToken }
            .skipNil()
    }
}
