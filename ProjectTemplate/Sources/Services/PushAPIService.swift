import ReactiveSwift

protocol HasPushAPI {
    var pushAPI: PushAPIServicing { get }
}

protocol PushAPIServicing {
    func registerToken(_ token: String) -> SignalProducer<Void, RequestError>
}

final class PushAPIService: PushAPIServicing {
    typealias Dependencies = HasJSONAPI

    private let jsonAPI: JSONAPIServicing

    // MARK: Initializers

    init(dependencies: Dependencies) {
        jsonAPI = dependencies.jsonAPI
    }

    func registerToken(_ token: String) -> SignalProducer<Void, RequestError> {
        jsonAPI.request(RequestAddress(path: "devices/token"), method: .put, parameters: ["token": token])
            .map { _ in }
    }
}
