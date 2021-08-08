//
//  AuthViewController.swift
//  iGallery
//
//  Created by Alexander Litvinov on 08.08.2021.
//

import UIKit

class AuthViewController: UIViewController {

    //MARK: - Private Properties
    private let customView = AuthView()
    
    //MARK: - Public Methods
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
