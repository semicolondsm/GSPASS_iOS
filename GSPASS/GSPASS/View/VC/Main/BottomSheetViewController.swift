//
//  bottomSheet.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/03.
//

import UIKit
import FloatingPanel

class BottomSheetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
