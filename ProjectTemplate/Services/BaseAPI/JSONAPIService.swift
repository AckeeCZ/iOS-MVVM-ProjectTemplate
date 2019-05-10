import ReactiveSwift

protocol HasJSONAPI {
    var jsonAPI: JSONAPIServicing { get }
}

protocol JSONAPIServicing {
    func request(_ address: RequestAddress, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding, headers: HTTPHeaders) -> SignalProducer<JSONResponse, RequestError>
    func upload(_ address: RequestAddress, method: HTTPMethod, parameters: [NetworkUploadable], headers: HTTPHeaders) -> SignalProducer<JSONResponse, RequestError>
}

final class JSONAPIService: JSONAPIServicing {
    typealias Dependencies = HasNetwork

    private let network: Networking

    // MARK: Initializers

    init(dependencies: Dependencies) {
        network = dependencies.network
    }

    // MARK: Public methods

    func request(_ address: RequestAddress, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding, headers: HTTPHeaders) -> SignalProducer<JSONResponse, RequestError> {
        return network.request(address, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .toJSON()
    }

    func upload(_ address: RequestAddress, method: HTTPMethod, parameters: [NetworkUploadable], headers: HTTPHeaders) -> SignalProducer<JSONResponse, RequestError> {
        return network.upload(address, method: method, parameters: parameters, headers: headers).toJSON()
    }
}

extension SignalProducer where Value == DataResponse, Error == RequestError {
    func toJSON() -> SignalProducer<JSONResponse, Error> {
        return attemptMap { dataResponse in
            do {
                let jsonResponse = try dataResponse.jsonResponse()
                return Result.success(jsonResponse)
            } catch {
                let networkError = NetworkError(error: error, request: nil, response: nil, data: dataResponse.data)
                return Result.failure(.network(networkError))
            }
        }
    }
}

extension JSONAPIServicing {
    func request(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [String: Any] = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        return request(address, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }

    func upload(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [NetworkUploadable], headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        return upload(address, method: method, parameters: parameters, headers: headers)
    }

    func request(path: String, method: HTTPMethod = .get, parameters: [String: Any] = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        return request(RequestAddress(path: path), method: method, parameters: parameters, encoding: encoding, headers: headers)
    }

    func upload(path: String, method: HTTPMethod = .get, parameters: [NetworkUploadable], headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        return upload(RequestAddress(path: path), method: method, parameters: parameters, headers: headers)
    }
}
