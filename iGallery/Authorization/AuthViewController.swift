//
//  AuthViewController.swift
//  iGallery
//
//  Created by Alexander Litvinov on 08.08.2021.
//

import UIKit

class AuthViewController: UIViewController {

    //MARK: - Private Properties
    private let authService: AuthService
    private let customView = AuthView()
    
    //MARK: - Init
    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
}

private extension AuthViewController {
    
    //MARK: - Private Methods
    @objc
    func loginButtonTapped() {
        authService.wakeUpSession()
    }
}
