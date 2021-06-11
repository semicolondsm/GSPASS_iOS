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

    public static let shared = BottomSheetViewModel()
    private let disposeBag = DisposeBag()

    struct Input {
        let issuePass: Driver<Void>
        let getNextPassTime: Driver<Void>
        let getUserPassInfo: Driver<Void>
    }

    struct Output {
        let resultOfIssuPass: Observable<(GSPassInfoModel?, String?)>
        let nextPassTime: Observable<String>
        let userPassInfo: Observable<GSPassInfoModel>
    }

    func transform(_ input: Input) -> Output {
        let resultOfIssuPass = PublishSubject<(GSPassInfoModel?, String?)>()
        let nextPassTime = PublishSubject<String>()
        let userPassInfo = PublishSubject<GSPassInfoModel>()

        input.issuePass.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(.issuePass, GSPassInfoModel.self).subscribe(onSuccess: { data in
                resultOfIssuPass.onNext((data, nil))
                resultOfIssuPass.onCompleted()
            }, onFailure: { error in
                switch error as? StatusCode {
                case .badRequest:
                    resultOfIssuPass.onNext((nil, "신청 시간이 아닙니다!"))
                default:
                    resultOfIssuPass.onNext((nil, "인터넷을 확인해주세요!"))
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)

        input.getNextPassTime.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(.getNextPassTime, GSPassTimeModel.self).subscribe(onSuccess: { dateModel in
                let dateString = dateModel.gsPassTime
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.dateFormat = "HH:mm:ss"
                if let convertDate = formatter.date(from: dateString!) {
                    let myDateFormatter = DateFormatter()
                    myDateFormatter.dateFormat = "HH:mm"
                    myDateFormatter.locale = Locale(identifier: "ko_KR")
                    let convertStr = myDateFormatter.string(from: convertDate)
                    nextPassTime.onNext("PASS 발급은 "+convertStr+" 부터 시작됩니다.")
                } else {
                    nextPassTime.onNext("")
                }
            }, onFailure: { _ in
                nextPassTime.onNext("")
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)

        input.getUserPassInfo.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(.getPassInfo, GSPassInfoModel.self).subscribe(onSuccess: { data in
                userPassInfo.onNext(data)
                userPassInfo.onCompleted()
            }, onFailure: { err in
                userPassInfo.onError(err)
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)

        return Output(resultOfIssuPass: resultOfIssuPass,
                      nextPassTime: nextPassTime,
                      userPassInfo: userPassInfo)
    }

}
