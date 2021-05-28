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
    
    func networking<T:Codable>(_ api: GSPASSAPI, _ networkModel: T.Type) -> Observable<T>{
        requestData(api.method, api.uri,
                    parameters: api.parameters,
                    encoding: api.encoding,
                    headers: api.header)
            .flatMap{ response, data -> Observable<T> in
                return Observable<T>.create{ observable in
                    switch response.statusCode {
                    case 200:
                        do {
                            let processedData: T = try JSONDecoder().decode(T.self, from: data)
                            observable.on(.next(processedData))
                        } catch(let error) {
                            observable.onError(error)
                        }
                    case 400: observable.onError(StatusCode.badRequest)
                    case 401: observable.onError(StatusCode.unauthorized)
                    case 403: observable.onError(StatusCode.forbidden)
                    case 404: observable.onError(StatusCode.notFound)
                    case 500: observable.onError(StatusCode.internalServerError)
                    default: observable.onError(StatusCode.unkown)
                    }
                    return Disposables.create()
                }
            }
    }
}

