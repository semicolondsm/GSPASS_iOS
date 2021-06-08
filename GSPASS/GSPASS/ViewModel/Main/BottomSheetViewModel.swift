//
//  BottomSheetViewModel.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/07.
//

import Foundation
import RxCocoa
import RxSwift

class BottomSheetViewModel: ViewModel {

    private let disposeBag = DisposeBag()

    struct Input {
        let issuePass: Driver<Void>
    }

    struct Output {
        let resultOfIssuPass: Observable<String>
    }

    func transform(_ input: Input) -> Output {
        let resultOfIssuPass = PublishSubject<String>()

        input.issuePass.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(.issuePass, EmptyResponseModel.self).subscribe(onSuccess: { _ in
                resultOfIssuPass.onCompleted()
            }, onFailure: { error in
                switch error as? StatusCode {
                case .badRequest:
                    resultOfIssuPass.onNext("신청 시간이 아닙니다!")
                default:
                    resultOfIssuPass.onNext("인터넷을 확인해주세요!")
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)

        return Output(resultOfIssuPass: resultOfIssuPass)
    }

}
