//
//  APIService.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import Alamofire
import RxSwift
import SVProgressHUD

enum CheckingType {
    case checked
    case unchecked
}

final class APIService {
    private let session: Session
    
    init(_ session: Session = Session.default) {
        self.session = session
    }
    
    func request<T: Decodable>(router: APIRouter, checking: CheckingType = .checked) -> Single<T> {
        if checking == .checked {
            SVProgressHUD.show()
            
        }
        return Single<T>.create { singleEvent in
            let request: DataRequest
            request = self.session.request(router)
            
            request.responseString { response in
                print("🌍[API]----Request: \(router.urlRequest?.httpMethod ?? "") " + (router.urlRequest?.url?.absoluteString ?? ""))
                print("[API]----Params: " + (router.params?.toJSONString() ?? ""))
                print("[API]----Response: " + (response.value ?? ""))
            }
            request.responseDecodable(of: T.self) { response in
                if checking == .checked {
                    SVProgressHUD.dismiss()
                }
                self.handleResponse(response, router, checking, singleEvent)
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension APIService {
    private func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>,
                                              _ router: APIRouter,
                                              _: CheckingType,
                                              _ singleEvent: @escaping (SingleEvent<T>) -> Void) {
        let responseDic = response.data?.convertToDictionary()
        let code = responseDic?["status_code"] as? Int
        let message = responseDic?["status_message"] as? String
        let success = responseDic?["success"] as? Bool
        
        switch response.result {
        case let .success(result):
            singleEvent(.success(result))
        case let .failure(errorResponse):
            switch errorResponse {
            case .responseSerializationFailed:
                if T.self == String.self, let data = response.data, let str = String(data: data, encoding: .utf8) {
                    // swiftlint:disable:next force_cast
                    singleEvent(.success(str as! T))
                    return
                }
            default:
                let httpCode = HttpStatusCode(rawValue: errorResponse.responseCode ?? 0) ?? .unknown
                singleEvent(.failure(APIErrorResponse(code: code, message: message, success: success, httpCode: httpCode)))
            }
        }
    }
}
