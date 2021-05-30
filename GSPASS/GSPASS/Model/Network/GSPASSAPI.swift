//
//  GSPASSAPI.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/25.
//

import Foundation
import Alamofire
import KeychainSwift

enum GSPASSAPI {
    // Authorization
    case register(_ registerModel: RegisterModel)
    case login(_ userId: String, _ password: String)
    case tokenRefresh
    case password
    case overlap
}

extension GSPASSAPI {

    public var uri: String {
        let baseUrl = "http://13.125.161.204:8080"
        return baseUrl + path
    }

    public var method: HTTPMethod {
        switch self {
        case .register,
             .login,
             .password:
            return .post
        case .overlap,
             .tokenRefresh:
            return .get
        }
    }

    public var parameters: Parameters? {
        switch self {
        case .register(let registerModel):
            return ["random_code": registerModel.random_code!,
                    "gcn": registerModel.gcn!,
                    "name": registerModel.name!,
                    "user_id": registerModel.user_id!,
                    "registerModel.password": registerModel.password!]
        case .login(let userId, let password):
            return ["user_id": userId,
                    "password": password]
        default:
            return nil
        }
    }

    public var encoding: ParameterEncoding {
        switch self.method {
        case .get:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }

    public var header: HTTPHeaders? {
        switch self {
        case .register,
             .login,
             .password,
             .overlap:
            return nil
        case .tokenRefresh:
            return ["refresh-token": "Bearer \(refreshToken)"]
        }
    }

    private var path: String {
        switch self {
        case .register:
            return "/register"
        case .login:
            return "/login"
        case .tokenRefresh:
            return "/refresh"
        case .password:
            return "/password"
        case .overlap:
            return "/overlap"
        }
    }

    private var accessTocken: String {
        let keychain = KeychainSwift()
        return keychain.get("ACCESS-TOKEN") ?? ""
    }

    private var refreshToken: String {
        let keychain = KeychainSwift()
        return keychain.get("REFRESH-TOKEN") ?? ""
    }

    private func encodingQuery(query: String) -> String {
        return query.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? query
    }
}
