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
    
    //MARK: - Public Properties
    weak var delegate: PhotoCellDelegate?
    static let reuseIdentifier = String(describing: CarouselViewCell.self)
    
    //MARK: - Private Properties
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    private var interactor: PhotoInteractor?
    
    private lazy var singleTapRecoginzer: UITapGestureRecognizer = {
        let recoginzer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        recoginzer.numberOfTapsRequired = 1
        addGestureRecognizer(recoginzer)
        return recoginzer
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupActivityIndicator()
        backgroundColor = .green
        
        _ = singleTapRecoginzer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func configure(with interactor: PhotoInteractor) {
        imageView.reset()
        interactor.downloadPhoto { [weak self] image, error in
            self?.imageView.image = image
            self?.activityIndicator.stopAnimating()
        }
        
        self.interactor?.cancelDownloading()
        self.interactor = interactor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newImageSize = CGSize(width: bounds.height, height: bounds.height)
        imageView.frame = CGRect(origin: .zero, size: newImageSize)
    }
}

private extension CarouselViewCell {
    
    //MARK: - Private Methods
    func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
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
        activityIndicator.style = .large
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        
        imageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    @objc func handleSingleTap() {
        delegate?.photoCellDidTap(self)
    }
}
