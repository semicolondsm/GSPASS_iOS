//
//  UITextField.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/31.
//

import UIKit

extension UITextField {
    func setTextField() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392478466, blue: 0.4391593933, alpha: 1)
        self.layer.cornerRadius = 5
        self.addLeftPadding()
    }

    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
