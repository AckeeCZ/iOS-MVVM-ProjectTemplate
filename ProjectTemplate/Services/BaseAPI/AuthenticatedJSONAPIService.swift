import ACKategories
import ReactiveSwift

protocol HasAuthenticatedJSONAPI {
    var authJSONAPI: JSONAPIServicing { get }
}

final class AuthenticatedJSONAPIService: UnauthorizedHandling, JSONAPIServicing {
    typealias Dependencies = HasJSONAPI & HasAuthHandler & HasCredentialsProvider

    private let jsonAPI: JSONAPIServicing
    private let authHandler: AuthHandling
    private let credentialsProvider: CredentialsProvider

    private var authorizationHeaders: HTTPHeaders { return credentialsProvider.credentials.map { ["Authorization": "Bearer " + $0.accessToken] } ?? [:] }

    // MARK: Initializers

    init(dependencies: Dependencies) {
        jsonAPI = dependencies.jsonAPI
        authHandler = dependencies.authHandler
        credentialsProvider = dependencies.credentialsProvider
    }

    // MARK: Public methods

    func request(_ address: RequestAddress, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding, headers: HTTPHeaders) -> SignalProducer<JSONResponse, RequestError> {
        let jsonAPI = self.jsonAPI

        return authorizationHeadersProducer()
            .flatMap(.latest) { jsonAPI.request(address, method: method, parameters: parameters, encoding: encoding, headers: $0 + headers) }
            .flatMapError { [unowned self] in
                self.unauthorizedHandler(error: $0, authHandler: self.authHandler, authorizationHeaders: self.authorizationHeaders) { [unowned self] in
                    self.request(address, method: method, parameters: parameters, encoding: encoding, headers: headers)
                }
        }
    }

    func upload(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [NetworkUploadable], headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        let jsonAPI = self.jsonAPI

        return authorizationHeadersProducer()
            .flatMap(.latest) { jsonAPI.upload(address, method: method, parameters: parameters, headers: $0 + headers) }
            .flatMapError { [unowned self] in
                self.unauthorizedHandler(error: $0, authHandler: self.authHandler, authorizationHeaders: self.authorizationHeaders) { [unowned self] in
                    self.upload(address, method: method, parameters: parameters, headers: headers)
                }
        }
    }

    // MARK: Private helpers

    private func authorizationHeadersProducer() -> SignalProducer<HTTPHeaders, RequestError> {
        return SignalProducer { [weak self] observer, _ in
            guard let self = self else { observer.sendInterrupted(); return }
            observer.send(value: self.authorizationHeaders)
            observer.sendCompleted()
        }
    }
}
