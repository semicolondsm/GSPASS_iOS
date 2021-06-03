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

class MainViewController: UIViewController {

    @IBOutlet weak var mealCollectionView: UICollectionView!
    @IBOutlet weak var personalActionBtn: UIBarButtonItem!

    private let disposeBag = DisposeBag()
    private let layout = CollectionViewPagingLayout()
    private let viewModel = MainViewModel()
    private var currentPage = 0

    private let getMeal = PublishSubject<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationbar()
        setCollectionView()
        bind()
    }

    func bind() {
        let input = MainViewModel.Input(getMeal: getMeal.asDriver(onErrorJustReturn: 0))
        let output = viewModel.transform(input)

        output.mealList.bind(to: mealCollectionView.rx.items(
                                cellIdentifier: "MealCollectionViewCell",
                                cellType: MealCollectionViewCell.self)) { _, item, cell in
            cell.bind(dateString: item.dateString, meal: item.meal)
            if self.layout.currentPage == 0 {
                self.layout.goToNextPage(animated: false)
            }

        }.disposed(by: disposeBag)

        personalActionBtn.rx.tap.subscribe(onNext: {
            self.openMenu()
        }).disposed(by: disposeBag)

        getMeal.onNext(0)
    }
}

// MARK: - ActionSheet
extension MainViewController {
    func openMenu() {
        let actionSheet = UIAlertController(title: "school name", message: "gcn", preferredStyle: .actionSheet)
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
