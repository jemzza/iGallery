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

    //MARK: - Pulic Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        
        let auth = AuthViewController(authService: authService)
        
        authService.delegate = self
        
        
        
        window?.rootViewController = auth
        window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    
    func authServiceShouldShow(for viewController: UIViewController) {
        print("authServiceShouldShow")
        viewController.modalPresentationStyle = .popover
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        print("SignIN")
        
        let viewController = GalleryViewController(photoService: photoService)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: Constants.Colors.titles,
            NSAttributedString.Key.font: UIFont(name: Constants.Font.medium, size: Constants.Font.Size.small)!
        ]
                navigationController.navigationBar.titleTextAttributes = attrs
//                navigationController.navigationBar.barStyle = .blackTranslucent
//                navigationController.navigationBar.barTintColor = .white
        window?.rootViewController = navigationController
    }
    
    func authServiceSignInDidFail(error: Error?) {
        print("authServiceSignInDidFail")
        window?.rootViewController?.present(UIAlertController.standard(error: error), animated: true, completion: nil)
    }
}
