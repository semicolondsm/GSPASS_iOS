//
//  ViewModelProtocol.swift
//  GSPASS
//
//  Created by κΉμμ on 2021/05/31.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
