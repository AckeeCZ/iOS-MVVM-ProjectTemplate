import Alamofire
import ReactiveSwift
import Reqres

protocol HasNetwork {
    var network: Networking { get }
}

protocol Networking {
    func request<RequestType: Encodable>(_ address: RequestAddress, method: HTTPMethod, parameters: RequestType?, encoder: ParameterEncoder, headers: HTTPHeaders) -> SignalProducer<DataResponse, RequestError>
    func upload(_ address: RequestAddress, method: HTTPMethod, parameters: [NetworkUploadable], headers: HTTPHeaders) -> SignalProducer<DataResponse, RequestError>
}

final class Network: Networking {
    private let session: Session = {
        let configuration = Reqres.defaultSessionConfiguration()
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        let session = Session(configuration: configuration)
        Reqres.sessionDelegate = session.delegate
        return session
    }()

    fileprivate static let networkCallbackQueue = DispatchQueue.global(qos: .background)

    // MARK: Public methods

    func request<RequestType: Encodable>(_ address: RequestAddress, method: HTTPMethod, parameters: RequestType?, encoder: ParameterEncoder, headers: HTTPHeaders) -> SignalProducer<DataResponse, RequestError> {
        let session = self.session
        return SignalProducer { observer, lifetime in
            let task = session.request(address, method: method, parameters: parameters, encoder: encoder, headers: headers)
                .validate()
                .handleResponse(observer: observer)

            lifetime.observeEnded {
                task.cancel()
            }
        }
    }

    func upload(_ address: RequestAddress, method: HTTPMethod, parameters: [NetworkUploadable], headers: HTTPHeaders) -> SignalProducer<DataResponse, RequestError> {
        let session = self.session
        return SignalProducer { observer, lifetime in
            let task = session.upload(
                multipartFormData: { formData in parameters.forEach { $0.append(multipart: formData) } },
                to: address,
                method: method,
                headers: headers)
                .validate()
                .handleResponse(observer: observer)

            lifetime.observeEnded {
                task.cancel()
            }
        }
    }
}

private extension DataRequest {
    @discardableResult
    func handleResponse(observer: Signal<DataResponse, RequestError>.Observer) -> Self {
        return responseData(queue: Network.networkCallbackQueue) { response in
            if let error = response.error {
                let networkError = NetworkError(error: error, request: response.request, response: response.response,
                                                data: response.data)

                observer.send(error: .network(networkError))
            } else if let httpResponse = response.response {
                let requestResponse = RequestResponse(statusCode: httpResponse.statusCode, request: response.request,
                                                      response: httpResponse, data: response.data)

                observer.send(value: requestResponse)
                observer.sendCompleted()
            } else {
                observer.sendInterrupted()
            }
        }
    }
}
