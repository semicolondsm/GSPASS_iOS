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
    
}

extension GSPASSAPI {
    
    public var url: String {
        
        let baseUrl = ""
        
        return baseUrl + path
    }
    
    public var method: HTTPMethod {
        switch self {
        }
    }
    
    public var parameters: Parameters? {
        switch self {
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
    
    public var header: HTTPHeader {
        switch self {
        }
    }
    
    
    private var path: String {
        switch self {
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
}
