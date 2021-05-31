//
//  AppDelegate.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/20.
//

import UIKit
import RxSwift
import KeychainSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()
    let keychain = KeychainSwift()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        HTTPClient.shared.networking(.tokenRefresh, TokenModel.self).subscribe(onNext: { token in
            self.keychain.set("ACCESS-TOKEN", forKey: token.access_token)
            self.keychain.set("REFRESH-TOKEN", forKey: token.refresh_token)
            self.setRootViewController("Main", "MainViewController")
        }, onError: { _ in
            self.setRootViewController("Auth", "LoginViewController")
        }).disposed(by: disposeBag)
        
        
        
        return true
    }
    
    private func setRootViewController(_ storyboardName: String, _ viewControllerIdentifier: String){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tutorialStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = tutorialStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

}

