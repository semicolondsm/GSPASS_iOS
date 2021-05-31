//
//  ViewModelProtocol.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/31.
//

import Foundation

protocol ViewModel {
    associatedtype input
    associatedtype output
        
    func transform(_ input: input) -> output
}
