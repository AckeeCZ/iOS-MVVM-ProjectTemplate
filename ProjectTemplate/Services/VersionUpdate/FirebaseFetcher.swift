import Firebase

public class FirebaseFetcher: Fetcher {

    private let key: String
    private let remoteConfig: RemoteConfig

    public var version: Int? {
        remoteConfig.configValue(forKey: key).numberValue?.intValue
    }

    // MARK: - Initialization

    public init(key: String) {
        self.key = key
        self.remoteConfig = RemoteConfig.remoteConfig()
    }

    // MARK: - Public interface

    public func fetch(completion: @escaping () -> Void) {
        remoteConfig.fetchAndActivate { [weak self] status, _ in
            guard status != .error else { return }
            completion()
        }
    }
}
