//
//  PassBtnViewer.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/09.
//

import UIKit
import RxSwift

class PassBtnViewer: UICollectionViewCell {

    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var availableToApplyTimeLabel: UILabel!

    private let disposeBag = DisposeBag()

    public func bind(_ availableToApplyTime: PublishSubject<String>) {
        availableToApplyTime.subscribe(onNext: {
            self.availableToApplyTimeLabel.text = $0
        }).disposed(by: disposeBag)
    }
}
