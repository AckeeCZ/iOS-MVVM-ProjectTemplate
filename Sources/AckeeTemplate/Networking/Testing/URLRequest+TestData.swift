#if DEBUG
import Foundation

extension URLRequest {
    static func test(
        url: URL = .ackeeCZ,
        headers: [String: String]? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        return request
    }
}
#endif
