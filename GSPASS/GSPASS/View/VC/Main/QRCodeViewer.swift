//
//  QRCodeViewer.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/09.
//

import UIKit
import RxSwift
import RxCocoa
import KeychainSwift

class QRCodeViewer: UICollectionViewCell {
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var waitingPersonCount: UILabel!

    private let disposeBag = DisposeBag()

    private var timerObservable: Disposable?

    public func bind(_ gsPassInfo: PublishSubject<GSPassInfoModel>) {
        generateQrCode()
        gsPassInfo.subscribe(onNext: { data in
            self.waitingPersonCount.text = String(data.previous_count)
            self.timer(timeStr: data.time_remaining)
        })
        .disposed(by: disposeBag)
    }

    private func generateQrCode() {
        let keychain = KeychainSwift()
        let swiftLeeOrangeColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        let qrURLImage = URL(string: keychain.get("ACCESS-TOKEN") ?? "")?.qrImage(using: swiftLeeOrangeColor)
        self.qrCodeImageView.image = UIImage(ciImage: qrURLImage!)
    }

    private func timer(timeStr: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm:ss"
        if let convertDate = formatter.date(from: timeStr) {
            let myDateFormatter = DateFormatter()
            myDateFormatter.locale = Locale(identifier: "ko_KR")
            myDateFormatter.dateFormat = "HH"
            var hour: Int = Int(myDateFormatter.string(from: convertDate)) ?? 0
            myDateFormatter.dateFormat = "mm"
            var min: Int = Int(myDateFormatter.string(from: convertDate)) ?? 0
            myDateFormatter.dateFormat = "ss"
            var sec: Int = Int(myDateFormatter.string(from: convertDate)) ?? 0
            timerObservable = Observable<Int>
                .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                .take(hour*3600 + min*60 + sec)
                .map { _ in
                    if sec > 0 {
                        sec -= 1
                    } else if min > 0 {
                        min -= 1
                        sec += 59
                    } else if hour > 0 {
                        hour -= 1
                        min += 59
                        sec += 59
                    }
                }
                .map {
                    return hour+min+sec != 0 ? "\(hour) : \(min) : \(sec)" : "밥먹자"
                }
                .bind(to: countdownLabel.rx.text)
        }
    }
}
