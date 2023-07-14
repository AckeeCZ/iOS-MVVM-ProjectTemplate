import Foundation
import Networking

public final class APIBuildNumberFetcher: MinBuildNumberFetcher {
    public struct CannotParseBuildNumber: Error { }
    
    public var minBuildNumber: Int {
        get async throws {
            let response = try await network.request(.init(url: url))
            let data = response.data ?? .init()
            
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let minBuildNumber = (jsonObject as AnyObject).value(forKeyPath: keyPath)
                .flatMap { $0 as? String }
                .flatMap { Int($0) }
            
            if let minBuildNumber {
                return minBuildNumber
            }
            
            throw CannotParseBuildNumber()
        }
    }
    
    private let network: Networking
    private let url: URL
    private let keyPath: String
    
    public init(
        network: Networking,
        url: URL,
        keyPath: String
    ) {
        self.network = network
        self.url = url
        self.keyPath = keyPath
    }
}
