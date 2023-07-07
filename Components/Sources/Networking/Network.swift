import Foundation

public protocol Networking {
    func request(_ request: URLRequest) -> Async<HTTPResponse>
}

public protocol HasNetwork {
    var network: Networking { get }
}

public final class Network: Networking {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request(_ request: URLRequest) -> Async<HTTPResponse> {
        .init { [session] in
            let (data, response) = try await session.data(for: request)
            
            return .init(
                request: request,
                response: response as? HTTPURLResponse,
                data: data
            )
        }
    }
}