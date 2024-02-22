import ACKategories
import FirebaseRemoteConfig

public final class FirebaseFetcher: MinBuildNumberFetcher {
    public var minBuildNumber: Int {
        get async throws {
            try await remoteConfig.fetchAndActivate()
            return remoteConfig[decodedValue: key] ?? Int.max
        }
    }
    
    private let key: String
    private let remoteConfig: RemoteConfig
    
    public init(
        key: String,
        remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()
    ) {
        self.key = key
        self.remoteConfig = remoteConfig
    }
}
