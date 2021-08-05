//
//  DetailViewCell.swift
//  iGallery
//
//  Created by Alexander Litvinov on 04.08.2021.
//

import UIKit

//protocol CarouselViewCellDelegate: AnyObject {
//    func CarouselViewCellDidTap(_ cell: CarouselViewCell)
//}

class CarouselViewCell: UICollectionViewCell, ViewCellProtocol {    
    
    // MARK: - Public Properties
    weak var delegate: PhotoCellDelegate?
    static let reuseIdentifier = String(describing: CarouselViewCell.self)
    
    // MARK: - Private Properties
    private let imageView = UIImageView()
    
    private lazy var singleTapRecoginzer: UITapGestureRecognizer = {
        let recoginzer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        recoginzer.numberOfTapsRequired = 1
        addGestureRecognizer(recoginzer)
        return recoginzer
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        backgroundColor = .green
        
        _ = singleTapRecoginzer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newImageSize = CGSize(width: bounds.height, height: bounds.height)
        imageView.frame = CGRect(origin: .zero, size: newImageSize)
        
    }
}

private extension CarouselViewCell {
    
    // MARK: - Private Methods
    func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    @objc func handleSingleTap() {
        delegate?.photoCellDidTap(self)
    }
}
