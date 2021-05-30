//
//  LoginModel.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/29.
//

import Foundation

struct TokenModel: Codable {
    let access_token: String
    let refresh_token: String
}
