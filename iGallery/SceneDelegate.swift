//
//  SceneDelegate.swift
//  iGallery
//
//  Created by Alexander Litvinov on 03.08.2021.
//

import UIKit
import VK_ios_sdk

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AuthServiceDelegate {

    //MARK: - Public properties
    var window: UIWindow?
    
    //MARK: - Private properties
    private let photoService = PhotoServiceRealization()
    private let authService = AuthServiceRealization()
    private var navigationController: UINavigationController!
    private var authVC: UIViewController!

    //MARK: - Pulic Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        authService.delegate = self
        
        let viewController = GalleryViewController(photoService: photoService, authService: authService)
        navigationController = UINavigationController(rootViewController: viewController)
        let attrs = [
            NSAttributedString.Key.foregroundColor: Constants.Colors.titles,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constants.Font.Size.small, weight: Constants.Font.Weight.f600)

        ]
        navigationController.navigationBar.titleTextAttributes = attrs
        
        authVC = AuthViewController(authService: authService)
                
        if UserDefaults.standard.bool(forKey: "isUserAuthorized") {
            window?.rootViewController = navigationController
        } else {
            window?.rootViewController = authVC
        }
        
        window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    
    func authServiceLogoutOutFromVK() {
        UserDefaults.standard.set(false, forKey: "isUserAuthorized")
        window?.rootViewController = authVC
    }
    
    func authServiceShouldShow(for viewController: UIViewController) {
        print("authServiceShouldShow")
        viewController.modalPresentationStyle = .popover
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        print("authServiceSignIn")
        UserDefaults.standard.set(true, forKey: "isUserAuthorized")
        window?.rootViewController = navigationController
    }
    
    func authServiceSignInDidFail(error: Error?) {
        print("authServiceSignInDidFail")
        window?.rootViewController?.present(UIAlertController.standard(error: error), animated: true, completion: nil)
    }
}
