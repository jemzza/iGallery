//
//  GalleryCollectionViewCell.swift
//  iGallery
//
//  Created by Alexander Litvinov on 03.08.2021.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public Properties
    static let reuseIdentifier = String(describing: GalleryCollectionViewCell.self)
    
    //MARK: - Private Properties
    private let imageView = UIImageView()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func configure(for image: UIImage) {
        imageView.image = image
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
}
