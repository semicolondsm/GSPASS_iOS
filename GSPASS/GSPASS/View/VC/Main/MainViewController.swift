//
//  MainViewController.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/25.
//

import UIKit
import CollectionViewPagingLayout

class MainViewController: UIViewController {

    @IBOutlet weak var mealCollectionView: UICollectionView!
    @IBOutlet weak var personalActionBtn: UIBarButtonItem!

    private let layout = CollectionViewPagingLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationbar()
        setCollectionView()
        bind()
    }
    
    func bind() {
    }
}

// MARK: - Collection View
extension MainViewController: UICollectionViewDataSource {
    func setCollectionView() {
        mealCollectionView.collectionViewLayout = layout
        mealCollectionView.isPagingEnabled = true
        layout.numberOfVisibleItems = nil
        mealCollectionView.dataSource = self
        registerCell()
    }

    func registerCell() {
        let nib = UINib(nibName: "MealCollectionViewCell", bundle: nil)
        mealCollectionView.register(nib, forCellWithReuseIdentifier: "MealCollectionViewCell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath)
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
