//
//  AuthView.swift
//  iGallery
//
//  Created by Alexander Litvinov on 08.08.2021.
//

import UIKit

class AuthView: UIView {
    
    //MARK: - Public Properties
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход через VK", for: .normal)
        button.backgroundColor = Constants.Colors.titles
        button.tintColor = Constants.Colors.buttonTitle
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.Font.Size.small, weight: Constants.Font.Weight.f500)

        button.layer.cornerRadius = 8
        return button
    }()
    
    //MARK: - Private Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.Font.Size.largeAuth, weight: Constants.Font.Weight.f700)
        label.text = "Mobile Up\nGallery"
        label.numberOfLines = 2
        label.textColor = Constants.Colors.titles
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        return stackView
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    //MARK: - Public Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
}

private extension AuthView {
    
    //MARK: - Private Methods
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(loginButton)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 140),
            verticalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            verticalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            verticalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            loginButton.leftAnchor.constraint(equalTo: verticalStackView.leftAnchor, constant: 0),
            loginButton.rightAnchor.constraint(equalTo: verticalStackView.rightAnchor, constant: 0)
        ])
    }
}
