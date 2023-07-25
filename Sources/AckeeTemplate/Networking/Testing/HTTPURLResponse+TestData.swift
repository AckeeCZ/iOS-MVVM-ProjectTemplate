#if DEBUG
import Foundation

extension HTTPURLResponse {
    static func test(
        url: URL = .ackeeCZ,
        statusCode: Int = 200,
        httpVersion: String? = nil,
        headerFields: [String: String]? = nil
    ) -> HTTPURLResponse? {
        .init(
            url: url,
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headerFields
        )
    }
}
#endif
