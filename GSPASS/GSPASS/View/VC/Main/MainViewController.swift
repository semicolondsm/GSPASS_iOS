//
//  MainViewController.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/25.
//

import UIKit
import RxCocoa
import RxSwift
import CollectionViewPagingLayout
import KeychainSwift
import FloatingPanel

class MainViewController: UIViewController {

    @IBOutlet weak var mealCollectionView: UICollectionView!
    @IBOutlet weak var personalActionBtn: UIBarButtonItem!

    private let disposeBag = DisposeBag()
    private let layout = CollectionViewPagingLayout()
    private let viewModel = MainViewModel()
    private var currentPage = 0
    private var userInfo = UserInfoModel(school_name: "", gcn: nil)

    private let getMeal = PublishSubject<Int>()
    private let getUserInfo = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationbar()
        setCollectionView()
        setFloatingPanel()
        bind()
    }

    func bind() {
        let input = MainViewModel.Input(getMeal: getMeal.asDriver(onErrorJustReturn: 0),
                                        getUserInfo: getUserInfo.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input)

        getUserInfo.onNext(())

        output.mealList.bind(to: mealCollectionView.rx.items(
                                cellIdentifier: "MealCollectionViewCell",
                                cellType: MealCollectionViewCell.self)) { _, item, cell in
            cell.bind(dateString: item.dateString, meal: item.meal)
            if self.layout.currentPage == 0 {
                self.layout.goToNextPage(animated: false)
            }
        }.disposed(by: disposeBag)

        output.userInfo.subscribe(onNext: { userInfo in
            self.userInfo = userInfo
        })
        .disposed(by: disposeBag)

        personalActionBtn.rx.tap.subscribe(onNext: {
            self.openMenu()
        }).disposed(by: disposeBag)

        getMeal.onNext(0)
    }
}

// MARK: - ActionSheet
extension MainViewController {
    func openMenu() {
        let actionSheet = UIAlertController(title: userInfo.school_name,
                                            message: userInfo.gcn ?? "",
                                            preferredStyle: .actionSheet)
        let changePassword = UIAlertAction(title: "비밀번호 변경", style: .default) { _ in
            //
        }
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            let keychainSwift = KeychainSwift()
            keychainSwift.clear()
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let vcName = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            vcName.modalPresentationStyle = .fullScreen
            self.present(vcName, animated: true, completion: nil)
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(changePassword)
        actionSheet.addAction(logout)
        actionSheet.addAction(cancle)
        actionSheet.view.tintColor = .white
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - Collection View
extension MainViewController: UICollectionViewDelegate {
    func setCollectionView() {
        mealCollectionView.collectionViewLayout = layout
        mealCollectionView.isPagingEnabled = true
        mealCollectionView.delegate = self
        layout.numberOfVisibleItems = nil
        registerCell()
    }

    func registerCell() {
        let nib = UINib(nibName: "MealCollectionViewCell", bundle: nil)
        mealCollectionView.register(nib, forCellWithReuseIdentifier: "MealCollectionViewCell")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentPage != layout.currentPage {
            currentPage = layout.currentPage
            getMeal.onNext(currentPage)
        }
    }
}

// MARK: - UI
extension MainViewController {
    func setNavigationbar() {
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 40.0))
        let icon = UIImageView(image: UIImage(named: "logo"))
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 0.0, y: 8.0, width: 100.0, height: 30.0)
        customView.addSubview(icon)
        let leftButton = UIBarButtonItem(customView: customView)
        navigationItem.leftBarButtonItem = leftButton

        personalActionBtn.image = UIImage(named: "customPerson")?.withRenderingMode(.alwaysOriginal)
    }
}

// MARK: - FloatingPanel
extension MainViewController: FloatingPanelControllerDelegate {
    func setFloatingPanel() {
        let fpc = FloatingPanelController(delegate: self)
        let contentViewcontroller = storyboard?
            .instantiateViewController(identifier: "BottomSheetViewController") as? BottomSheetViewController

        fpc.surfaceView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        fpc.surfaceView.appearance.cornerRadius = 24.0
        fpc.surfaceView.appearance.shadows = []
        fpc.surfaceView.appearance.borderWidth = 1.0 / traitCollection.displayScale
        fpc.surfaceView.appearance.borderColor = UIColor.black.withAlphaComponent(0.2)
        fpc.layout = MyFloatingPanelLayout()

        fpc.set(contentViewController: contentViewcontroller)
        fpc.addPanel(toParent: self)
    }
}
