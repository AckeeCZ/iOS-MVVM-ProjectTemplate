import Firebase
import ReactiveSwift

protocol HasFirebasePushObserver {
    var firebasePushObserver: FirebasePushObserving { get }
}

protocol FirebasePushObserving {
    func start()
}

final class FirebasePushObserver: FirebasePushObserving {
    typealias Dependencies = HasPushManager

    private let dependencies: Dependencies

    // MARK: Initializers

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Public interface

    func start() {
        dependencies.pushManager.actions.registerToken <~ NotificationCenter.default.reactive
            .notifications(forName: .InstanceIDTokenRefresh)
            .filterMap { _ in InstanceID.instanceID().token() }
    }
}
