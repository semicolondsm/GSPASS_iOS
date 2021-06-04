//
//  LoginViewModel.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/29.
//

import Foundation
import RxCocoa
import RxSwift
import KeychainSwift

class LoginViewModel: ViewModel {

    private let disposeBag = DisposeBag()
    private let keychain = KeychainSwift()

    struct Input {
        let idTextFieldSubject: Driver<String>
        let pwdTextFieldSubject: Driver<String>
        let loginBtnSubject: Driver<Void>
    }

    struct Output {
        let loginResult: Observable<String>
    }

    func transform(_ input: Input) -> Output {
        let loginResult = PublishSubject<String>()

        input.loginBtnSubject.asObservable()
            .withLatestFrom(
                Observable.combineLatest(
                    input.idTextFieldSubject.asObservable(),
                    input.pwdTextFieldSubject.asObservable()
                )
            )
            .subscribe(onNext: { (id, pwd) in
                HTTPClient.shared.networking(.login(id, pwd), TokenModel.self)
                    .subscribe(onSuccess: { token in
                        self.keychain.set(token.access_token, forKey: "ACCESS-TOKEN")
                        self.keychain.set(token.refresh_token, forKey: "REFRESH-TOKEN")
                        loginResult.onCompleted()
                    }, onFailure: { error in
                        switch error as? StatusCode {
                        case .badRequest, .notFound:
                            loginResult.onNext("아이디 또는 비밀번호를 확인해주세요!")
                        default:
                            loginResult.onNext("인터넷을 확인해주세요!")
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        return Output(loginResult: loginResult)
    }
}
