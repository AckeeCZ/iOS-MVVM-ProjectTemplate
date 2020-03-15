import ReactiveSwift

protocol HasJSONAPI {
    var jsonAPI: JSONAPIServicing { get }
}

protocol JSONAPIServicing {
    func request<RequestType: Encodable>(_ address: RequestAddress, method: HTTPMethod, parameters: RequestType?, encoder: ParameterEncoder, headers: HTTPHeaders) -> SignalProducer<JSONResponse, RequestError>
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

    func request<RequestType: Encodable>(_ address: RequestAddress, method: HTTPMethod, parameters: RequestType?, encoder: ParameterEncoder, headers: HTTPHeaders) -> SignalProducer<JSONResponse, RequestError> {
        network.request(address, method: method, parameters: parameters, encoder: encoder, headers: headers)
            .toJSON()
    }

    func upload(_ address: RequestAddress, method: HTTPMethod, parameters: [NetworkUploadable], headers: HTTPHeaders) -> SignalProducer<JSONResponse, RequestError> {
        network.upload(address, method: method, parameters: parameters, headers: headers)
            .toJSON()
    }
}

extension SignalProducer where Value == DataResponse, Error == RequestError {
    func toJSON() -> SignalProducer<JSONResponse, Error> {
        attemptMap { dataResponse in
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
    func request<RequestType: Encodable>(_ address: RequestAddress, method: HTTPMethod = .get, parameters: RequestType?, encoder: ParameterEncoder = URLEncoder.default, headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        request(address, method: method, parameters: parameters, encoder: encoder, headers: headers)
    }

    func request(_ address: RequestAddress, method: HTTPMethod = .get, headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        // To make sure that compiler can infer `RequestType` we need to provide some `Encodable` type, as long as we want to serialize `nil`,
        // it doesn't matter what `Encodable` type it is, so we just use `String`
        request(address, method: method, parameters: String?.none, headers: headers)
    }

    func upload(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [NetworkUploadable], headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        upload(address, method: method, parameters: parameters, headers: headers)
    }

    func request<RequestType: Encodable>(path: String, method: HTTPMethod = .get, parameters: RequestType? = nil, encoder: ParameterEncoder = URLEncoder.default, headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        request(RequestAddress(path: path), method: method, parameters: parameters, encoder: encoder, headers: headers)
    }

    func request(path: String, method: HTTPMethod = .get, headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        request(RequestAddress(path: path), method: method, headers: headers)
    }

    func upload(path: String, method: HTTPMethod = .get, parameters: [NetworkUploadable], headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        upload(RequestAddress(path: path), method: method, parameters: parameters, headers: headers)
    }
}
