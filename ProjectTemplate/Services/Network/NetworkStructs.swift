import Alamofire

typealias DataResponse = RequestResponse<Data>
typealias JSONResponse = RequestResponse<Any>

struct RequestAddress {
    let url: URL
}

extension RequestAddress {
    init(path: String, baseURL: URL = Environment.API.baseURL) {
        // swiftlint:disable force_unwrapping
        url = URL(string: path, relativeTo: baseURL)!
    }
}

struct RequestResponse<Value> {
    let statusCode: Int
    let request: URLRequest?
    let response: HTTPURLResponse?
    let data: Value?

    var headers: HTTPHeaders { return response?.allHeaderFields as? HTTPHeaders ?? [:] }
}

enum RequestError: Error {
    case network(NetworkError)
    case upload(Error)
    case missingRefreshToken
}

struct NetworkError: Error {
    let error: Error
    let request: URLRequest?
    let response: HTTPURLResponse?
    let data: Data?

    var statusCode: Int? { return response?.statusCode }
}

extension RequestResponse where Value == Data {
    func jsonResponse() throws -> JSONResponse {
        let json = try data.flatMap { $0.isEmpty ? nil : try JSONSerialization.jsonObject(with: $0, options: .allowFragments) }

        return JSONResponse(statusCode: statusCode, request: request, response: response, data: json)
    }
}
