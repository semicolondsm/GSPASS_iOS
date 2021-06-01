//
//  HTTPClirnt.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/25.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class HTTPClient {
    static let shared = HTTPClient()

    func networking<T: Codable>(_ api: GSPASSAPI, _ networkModel: T.Type) -> Observable<T> {
        requestData(api.method, api.uri,
                    parameters: api.parameters,
                    encoding: api.encoding,
                    headers: api.header)
            .flatMap { response, data -> Single<T> in
                return Single<T>.create { single in
                    switch response.statusCode {
                    case 200:
                        do {
                            let processedData: T = try JSONDecoder().decode(T.self, from: data)
                            single(.success(processedData))
                        } catch let error {
                            single(.failure(error))
                        }
                    case 400: single(.failure(StatusCode.badRequest))
                    case 401: single(.failure(StatusCode.unauthorized))
                    case 403: single(.failure(StatusCode.forbidden))
                    case 404: single(.failure(StatusCode.notFound))
                    case 500: single(.failure(StatusCode.internalServerError))
                    default: single(.failure(StatusCode.unkown))
                    }
                    return Disposables.create()
                }
            }
    }
}

struct EmptyResponseModel: Codable { }
