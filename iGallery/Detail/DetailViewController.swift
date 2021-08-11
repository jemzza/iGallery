//
//  DetailViewController.swift
//  iGallery
//
//  Created by Alexander Litvinov on 04.08.2021.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func detailViewController(_ controller: DetailViewController, didChangeOverlookedIndex: Int)
}

class DetailViewController: UIViewController {
    
    //MARK: - Public Properties
    override var prefersStatusBarHidden: Bool {
        return navigationBarHidden
    }
    
    weak var delegate: DetailViewControllerDelegate?
    
    //MARK: - Private Properties
    private var collectionView: UICollectionView!
    private var carouselCollectionView: UICollectionView!
    private var navigationBarHidden = false
    private let photoService: PhotoService
    private(set) var  overlookedIndex: Int
    
    //MARK: - init
    init(forIndex overlookedIndex: Int, photoService: PhotoService ) {
        self.overlookedIndex = overlookedIndex
        self.photoService = photoService
        super.init(nibName: nil, bundle: nil)
        let date = photoService.photoInteractor(forPhotoWithIndex: overlookedIndex)?.date
        title = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupShareButton()
        setupСarouselCollectionView()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let indexPath = IndexPath(item: overlookedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}

//MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        if collectionView == carouselCollectionView {
            identifier = CarouselViewCell.reuseIdentifier
        } else {
            identifier = PhotoViewCell.reuseIdentifier
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ViewCellProtocol,
              let photoInteractor = photoService.photoInteractor(forPhotoWithIndex: indexPath.row) else {
            assert(false, "Cell for gallery view must be of type PhotoViewCell or CarouselViewCell")
            return UICollectionViewCell()
        }
        
        if collectionView != carouselCollectionView {
            title = photoInteractor.date
        }
        
        cell.configure(with: photoInteractor)
        cell.delegate = self
        
        return cell
    }
}

//MARK: - Delegate
extension DetailViewController: PhotoCellDelegate {
    
    func photoCellDidTap(_ cell: ViewCellProtocol) {
        toggleNavigationBar()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == carouselCollectionView {
            return CGSize(width: collectionView.bounds.height,
                          height: collectionView.bounds.height)
        }
        return CGSize(width: collectionView.bounds.width - Static.spacingPhoto,
                      height: collectionView.bounds.height)
    }
}

private extension DetailViewController {
    
    //MARK: - Private Nested
    struct Static {
        static let spacingCarousel: CGFloat = 2.0
        static let spacingPhoto: CGFloat = 10.0
        
    }
    
    //MARK: - Private Methods
    func setupСarouselCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Static.spacingCarousel
        layout.sectionInset = UIEdgeInsets(
            top: 0.0,
            left: Static.spacingCarousel / 2,
            bottom: 0.0,
            right: Static.spacingCarousel / 2
        )
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        
        collectionView.register(
            CarouselViewCell.self,
            forCellWithReuseIdentifier: CarouselViewCell.reuseIdentifier
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -Static.spacingCarousel / 2),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Static.spacingCarousel / 2),
        ])
        
        self.carouselCollectionView = collectionView
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Static.spacingPhoto
        layout.sectionInset = UIEdgeInsets(
            top: 0.0,
            left: Static.spacingPhoto / 2,
            bottom: 0.0,
            right: Static.spacingPhoto / 2
        )
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            PhotoViewCell.self,
            forCellWithReuseIdentifier: PhotoViewCell.reuseIdentifier
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.allowsMultipleSelection = true
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: carouselCollectionView.topAnchor, constant: -10),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -Static.spacingPhoto / 2),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Static.spacingPhoto / 2),
        ])
        
        self.collectionView = collectionView
    }
    
    func toggleNavigationBar() {
        navigationBarHidden.toggle()
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(navigationBarHidden, animated: false)
    }
    
    func setupBackButton() {
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed))
        backBarButton.tintColor = .black
        self.navigationItem.leftBarButtonItems = [backBarButton]
    }
    
    func setupShareButton() {
        let detailButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonPressed))
        detailButton.tintColor = .black
        self.navigationItem.rightBarButtonItems = [detailButton]
    }
    
    @objc
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func shareButtonPressed() {
        guard let cell = self.collectionView.cellForItem(at: IndexPath(item: self.overlookedIndex, section: 0)) as? PhotoViewCell,
              let image = cell.getImage() else
        { return }
        let items = ["This is Mobile Up!", image] as [Any]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
}


extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        overlookedIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        delegate?.detailViewController(self, didChangeOverlookedIndex: overlookedIndex)
        
            self.carouselCollectionView.scrollToItem(at: IndexPath(item: self.overlookedIndex, section: 0), at: .centeredHorizontally, animated: true)
        print("scrollViewDidEndDecelerating")
    }
}
