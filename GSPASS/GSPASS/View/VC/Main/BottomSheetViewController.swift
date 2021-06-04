//
//  bottomSheet.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/03.
//

import UIKit
import FloatingPanel

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var passButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - UI
extension BottomSheetViewController {
    func setUI() {
        passButton.layer.cornerRadius = passButton.frame.height/2
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
