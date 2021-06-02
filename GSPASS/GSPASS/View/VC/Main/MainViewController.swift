//
//  MainViewController.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/25.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var breakfastMealLabel: UILabel!
    @IBOutlet weak var lunchMealLabel: UILabel!
    @IBOutlet weak var dinerMealLabel: UILabel!
    @IBOutlet weak var personalActionBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationbar()
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
