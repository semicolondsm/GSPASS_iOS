//
//  LoginViewController.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/29.
//

import UIKit
import RxCocoa
import RxSwift
import Loaf

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardNotification()
        setTextFields()
        bind()
    }

    func bind() {
        let input = LoginViewModel.Input(idTextFieldSubject: idTextField.rx.text.orEmpty.asDriver(),
                                         pwdTextFieldSubject: pwdTextField.rx.text.orEmpty.asDriver(),
                                         loginBtnSubject: loginButton.rx.tap.asDriver())
        let output = viewModel.transform(input)

        output.loginResult.subscribe(onNext: { errorMessage in
            Loaf(errorMessage, state: .error, location: .top, sender: self).show()
        }, onCompleted: {
            // 메인화면으로 이동
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vcName = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
            vcName.modalPresentationStyle = .fullScreen
            self.present(vcName, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)

        registerButton.rx.tap.subscribe(onNext: {
            // 회원가입 화면으로 이동
            print("!")
        })
        .disposed(by: disposeBag)
    }

}

// MARK: - TextFiled
extension LoginViewController: UITextFieldDelegate {
    func setTextFields() {
        idTextField.delegate = self
        pwdTextField.delegate = self
        idTextField.setTextField()
        pwdTextField.setTextField()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Keyboard event
extension LoginViewController {
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
      }

    @objc private func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let window = UIApplication.shared.windows[0]
        let bottomPadding = window.safeAreaInsets.bottom
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
        movingView.transform = CGAffineTransform(translationX: 0, y: (-keyboardHeight+bottomPadding)/3)
      }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        movingView.transform = .identity
    }
}
