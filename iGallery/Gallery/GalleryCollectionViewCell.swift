//
//  GalleryCollectionViewCell.swift
//  iGallery
//
//  Created by Alexander Litvinov on 03.08.2021.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public Nested
    static let reuseIdentifier = String(describing: GalleryCollectionViewCell.self)
    
    //MARK: - Public Properties
    var image: UIImage? {
        return imageView.image
    }
    
    //MARK: - Private Properties
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    private var interactor: PhotoInteractor?
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupActivityIndicator()
        imageView.reset()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func configure(for interactor: PhotoInteractor) {
        imageView.reset()
        interactor.downloadPhoto { [weak self] image, error in
            self?.imageView.image = image
            self?.activityIndicator.stopAnimating()
        }
        self.interactor?.cancelDownloading()
        self.interactor = interactor
    }
}

private extension GalleryCollectionViewCell {
    
    func setupImageView() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupActivityIndicator() {
       
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
