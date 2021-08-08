//
//  PhotoViewCell.swift
//  iGallery
//
//  Created by Alexander Litvinov on 05.08.2021.
//

import UIKit

//protocol PhotoViewCellDelegate: AnyObject {
//     func photoViewCellDidTap(_ cell: PhotoViewCell)
// }

protocol PhotoCellDelegate: AnyObject {
    func photoCellDidTap(_ cell: ViewCellProtocol)
}

class PhotoViewCell: UICollectionViewCell, ViewCellProtocol {
    
    //MARK: - Public Nested
    static let reuseIdentifier = String(describing: PhotoViewCell.self)
    
    //MARK: - Public Properties
    weak var delegate: PhotoCellDelegate?
    
    //MARK: - Private Properties
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    private var interactor: PhotoInteractor?
    
    private lazy var singleTapRecoginzer: UITapGestureRecognizer = {
        let recoginzer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        recoginzer.numberOfTapsRequired = 1
        addGestureRecognizer(recoginzer)
        return recoginzer
    }()
    
    private lazy var doubleTapRecoginzer: UITapGestureRecognizer = {
        let recoginzer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        recoginzer.numberOfTapsRequired = 2
        recoginzer.delegate = self
        addGestureRecognizer(recoginzer)
        return recoginzer
    }()
    
    //MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
        setupImageView()
        imageView.reset()
                
        _ = singleTapRecoginzer
        _ = doubleTapRecoginzer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func configure(with interactor: PhotoInteractor) {
        imageView.reset()
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        
        interactor.downloadPhoto { [weak self] image, error in
            self?.imageView.image = image
            self?.activityIndicator.stopAnimating()
//            self?.setNeedsLayout()
//            self?.layoutIfNeeded()
            //            guard let self = self else { return }
            //            UIView.transition(
            //                with: self.imageView,
            //                duration: 0.2,
            //                options: [.transitionCrossDissolve],
            //                animations: {
            //                    self.imageView.image = image
            //                    self.setNeedsLayout()
            //                    self.layoutIfNeeded()
            //            },
            //                completion: nil
            //            )
        }
        
        
        
        self.interactor?.cancelDownloading()
        self.interactor = interactor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        guard let image = imageView.image,
              scrollView.zoomScale == scrollView.minimumZoomScale else { return }
        
        let imageSize = image.size
        let imageAspect = imageSize.height / imageSize.width
        let boundsAspect = bounds.height / bounds.width
        
        let newImageSize: CGSize
        if imageAspect > boundsAspect {
            newImageSize = CGSize(width: ceil(bounds.height / imageAspect), height: bounds.height)
        } else {
            newImageSize = CGSize(width: bounds.width, height: ceil(bounds.width * imageAspect))
        }
        
        imageView.frame = CGRect(origin: .zero, size: newImageSize)
        scrollView.contentSize = imageView.frame.size
        
        updateInsets()
    }
    
}

//MARK: - UIGestureRecognizerDelegate
extension PhotoViewCell: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return gestureRecognizer === doubleTapRecoginzer
    }
    
}

//MARK: - UIScrollViewDelegate
extension PhotoViewCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateInsets()
    }
    
}

private extension PhotoViewCell {
    
    //MARK: - Private Methods
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
    
    func setupScrollView() {
        addSubview(scrollView)
        scrollView.delegate = self
        
        scrollView.bouncesZoom = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        
        scrollView.autoresizesSubviews = true
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func setupImageView() {
        setupActivityIndicator()
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
    func updateInsets() {
        let verticalInset = bounds.height > imageView.frame.height ?
            ceil((bounds.height - imageView.frame.height) / 2) : 0
        
        let horizontalInset = bounds.width > imageView.frame.width ?
            ceil((bounds.width - imageView.frame.width) / 2) : 0
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
    
    @objc func handleSingleTap() {
        delegate?.photoCellDidTap(self)
        
    }
    
    @objc func handleDoubleTap() {
        if scrollView.zoomScale != scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let point = doubleTapRecoginzer.location(in: self)
            let pointInImageView = imageView.convert(point, from: self)
            
            let size = CGSize(width: bounds.width / scrollView.maximumZoomScale,
                              height: bounds.height / scrollView.maximumZoomScale)
            
            let origin = CGPoint(x: pointInImageView.x - size.width / 2.0,
                                 y: pointInImageView.y - size.width / 2.0)
            
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }
    
}
