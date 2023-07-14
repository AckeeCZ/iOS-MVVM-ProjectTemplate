import Foundation

public protocol MinBuildNumberFetcher {
    var minBuildNumber: Int { get async throws }
}
