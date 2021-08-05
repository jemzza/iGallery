//
//  SceneDelegate.swift
//  iGallery
//
//  Created by Alexander Litvinov on 03.08.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let viewController = GalleryViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: Constants.Colors.titles,
            NSAttributedString.Key.font: UIFont(name: Constants.Font.main, size: Constants.Font.Size.small)!
        ]

        navigationController.navigationBar.titleTextAttributes = attrs
        navigationController.navigationBar.barTintColor = .white
    }

}
