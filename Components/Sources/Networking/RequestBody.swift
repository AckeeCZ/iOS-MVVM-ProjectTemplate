import Foundation

public protocol Encoder: AnyObject {
    static var contentType: String { get }
    
    func encode<T: Encodable>(_ encodable: T) throws -> Data
}

extension JSONEncoder: Encoder {
    public static var contentType: String { "application/json" }
}

public struct RequestBody {
    public let contentType: String
    public let data: Data
    
    public init(
        contentType: String,
        data: Data
    ) {
        self.contentType = contentType
        self.data = data
    }
    
    public init<T: Encodable>(_ encodable: T, encoder: Encoder) throws {
        contentType = type(of: encoder).contentType
        data = try encoder.encode(encodable)
    }
    
    public init(
        jsonDictionary dict: [String: Any],
        options: JSONSerialization.WritingOptions = [
            .prettyPrinted,
            .sortedKeys,
        ]
    ) throws {
        try self.init(jsonObject: dict, options: options)
    }
    
    public init(
        jsonArray array: [Any],
        options: JSONSerialization.WritingOptions = [
            .prettyPrinted,
            .sortedKeys,
        ]
    ) throws {
        try self.init(jsonObject: array, options: options)
    }
    
    public init(formURLEncoded dict: [String: String]) throws {
        let data = dict.compactMap { key, value in
            guard !key.isEmpty, !value.isEmpty,
                  let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let encodedValue = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else { return nil }
            
            return encodedKey + "=" + encodedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
        
        guard let data else {
            struct CannotEncodeData: Error { }
            throw CannotEncodeData()
        }
        
        self.data = data
        self.contentType = "application/x-www-form-urlencoded"
    }
    
    private init(
        jsonObject: Any,
        options: JSONSerialization.WritingOptions = [
            .prettyPrinted,
            .sortedKeys,
        ]
    ) throws {
        data = try JSONSerialization.data(
            withJSONObject: jsonObject,
            options: options
        )
        contentType = JSONEncoder.contentType
    }
}

extension RequestBody: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Any)...) {
        try! self.init(jsonDictionary: .init(elements) { $1 })
    }
}

extension RequestBody: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Any...) {
        try! self.init(jsonArray: elements)
    }
}
