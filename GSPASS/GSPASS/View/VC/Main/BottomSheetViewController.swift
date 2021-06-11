//
//  bottomSheet.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/03.
//

import UIKit
import Loaf
import RxSwift
import RxCocoa
import FloatingPanel
import CollectionViewPagingLayout

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var pageView: UICollectionView!

    private let disposeBag = DisposeBag()

    private let layout = CollectionViewPagingLayout()

    private let issuePass = PublishSubject<Void>()
    private let getNextPassTime = PublishSubject<Void>()
    private let getUserPassInfo = PublishSubject<Void>()

    private let availableToApplyTime = PublishSubject<String>()
    private let userPassInfo = PublishSubject<GSPassInfoModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setCollectionView()
        getUserPassInfo.onNext(())
        getNextPassTime.onNext(())
    }

    func bind() {
        let input = BottomSheetViewModel.Input(issuePass: issuePass.asDriver(onErrorJustReturn: ()),
                                               getNextPassTime: getNextPassTime.asDriver(onErrorJustReturn: ()),
                                               getUserPassInfo: getUserPassInfo.asDriver(onErrorJustReturn: ()))
        let output = BottomSheetViewModel.shared.transform(input)

        output.nextPassTime.subscribe(onNext: { str in
            self.availableToApplyTime.onNext(str)
        })
        .disposed(by: disposeBag)

        output.resultOfIssuPass.subscribe(onNext: { data, err in
            if let errMessage = err {
                Loaf(errMessage, state: .error, location: .bottom, sender: self).show()
            } else {
                self.userPassInfo.onNext(data!)
                self.layout.goToNextPage()
            }
        })
        .disposed(by: disposeBag)

        output.userPassInfo.subscribe(onNext: { data in
            self.userPassInfo.onNext(data)
            self.layout.goToNextPage()
        })
        .disposed(by: disposeBag)
    }
}

extension BottomSheetViewController: UICollectionViewDelegate {

    func setCollectionView() {
        pageView.collectionViewLayout = layout
        pageView.isPagingEnabled = true
        pageView.delegate = self
        pageView.isScrollEnabled = false
        layout.numberOfVisibleItems = nil
        registerCell()

        Observable<[BottomSheetPageType]>.of([.passBtnViewer, .qrCodeViewer])
            .bind(to: pageView.rx.items) { cv, row, item -> UICollectionViewCell in
                let indexPath = IndexPath(row: row, section: 0)
                switch item {
                case .passBtnViewer:
                    let page = cv.dequeueReusableCell(withReuseIdentifier: "passBtnViewerCell",
                                                      for: indexPath) as? PassBtnViewer
                    page?.bind(self.availableToApplyTime)
                    page?.passBtn.rx.tap.subscribe(onNext: {
                        self.issuePass.onNext(())
                    })
                    .disposed(by: self.disposeBag)
                    return page!
                case .qrCodeViewer:
                    let page = cv.dequeueReusableCell(withReuseIdentifier: "QRCodeViewerCell",
                                                      for: indexPath) as? QRCodeViewer
                    page?.bind(self.userPassInfo)
                    return page!
                }
            }
            .disposed(by: disposeBag)
    }

    func registerCell() {
        let passBtnViewerNib = UINib(nibName: "passBtnViewer", bundle: nil)
        pageView.register(passBtnViewerNib, forCellWithReuseIdentifier: "passBtnViewerCell")
        let qrCodeViewerNib = UINib(nibName: "QRCodeViewer", bundle: nil)
        pageView.register(qrCodeViewerNib, forCellWithReuseIdentifier: "QRCodeViewerCell")
    }

    private enum BottomSheetPageType {
        case passBtnViewer
        case qrCodeViewer
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 60.0, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
