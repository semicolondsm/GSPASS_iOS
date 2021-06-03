//
//  StringArray.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/03.
//

import Foundation

extension Array {
    func toString() -> String {
        var string: String = ""
        for item in self {
            string += "\(item) "
        }
        return string
    }
}
