// Aliases for common used types

import Foundation

import struct Alamofire.HTTPMethod
import protocol Alamofire.ParameterEncoder
import struct Alamofire.HTTPHeaders
import class Alamofire.URLEncodedFormParameterEncoder
import class Alamofire.JSONEncoder
import class Alamofire.MultipartFormData

typealias HTTPMethod = Alamofire.HTTPMethod
typealias ParameterEncoder = Alamofire.ParameterEncoder
typealias HTTPHeaders = Alamofire.HTTPHeaders
typealias URLEncoder = Alamofire.URLEncodedFormParameterEncoder
typealias JSONEncoder = Alamofire.JSONEncoder
typealias MultipartFormData = Alamofire.MultipartFormData

typealias IdentifierType = Int64
typealias TextAttributes = [NSAttributedString.Key: Any]
