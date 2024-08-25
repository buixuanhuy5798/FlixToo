//
//  APIError.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import Foundation

enum HttpStatusCode: Int, Error {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case notAllowed = 405
    case networkError = 1
    case invalidData = 109
    case unknown
    case maintain = 503

    var localizedMessage: String {
        switch self {
        case .networkError:
            return "Không có kết nối internet"
        default:
            return ""
        }
    }
}

struct APIErrorResponse: Decodable {
    var message: String?
    var code: Int?
    var success: Bool?
    var httpCode: HttpStatusCode?
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case messsage = "status_message"
        case success = "success"
    }
    
    init(code: Int?, message: String?, success: Bool?, httpCode: HttpStatusCode) {
        self.code = code
        self.message = message
        self.success = success
        self.httpCode = httpCode
    }
    
    init(from _: Decoder) throws {}
}

extension APIErrorResponse: LocalizedError {
    public var errorDescription: String? {
        return "Code: \(code) - \(message ?? "")"
    }
}
