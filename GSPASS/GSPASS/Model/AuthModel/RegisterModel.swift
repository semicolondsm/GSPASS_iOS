//
//  RegisterModel.swift
//  GSPASS
//
//  Created by κΉμμ on 2021/05/26.
//

import Foundation

struct RegisterModel: Codable {
    var random_code: String?
    var gcn: String?
    var name: String?
    var user_id: String?
    var password: String?
}
