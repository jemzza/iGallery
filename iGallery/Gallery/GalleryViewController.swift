//
//  ViewController.swift
//  iGallery
//
//  Created by Alexander Litvinov on 03.08.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    //MARK: - Private Properties
    private let photoService: PhotoService
    private let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: GalleryViewLayout())
    
    //MARK: - init
    init(photoService: PhotoService) {
        self.photoService = photoService
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Public Methods
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getPhotos()
        setupCollectionView()
        setupNavigationBar()
    }
}

//MARK: - UICollectionViewDataSourcePrefetching
extension GalleryViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
}

//MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController(forIndex: indexPath.row, photoService: photoService)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photoService.count)
        return photoService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier, for: indexPath) as? GalleryCollectionViewCell,
              let photoInteractor = photoService.photoInteractor(forPhotoWithIndex: indexPath.row) else {
            assert(false, "Cell for gallery view must be of type GallleryViewCell")
            return UICollectionViewCell()
        }
//        cell.configure(for: UIImage(named: indexPath.item % 2 == 0 ? "ref011" : "ref012")!)
        cell.configure(for: photoInteractor)
        return cell
    }
}

//MARK: - DetailViewControllerDelegate

extension GalleryViewController: DetailViewControllerDelegate {
    
    func detailViewController(_ controller: DetailViewController, didChangeOverlookedIndex index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredVertically,
            animated: false
        )
    }
    
}

private extension GalleryViewController {
    
    //MARK: - Private Methods
    func setupCollectionView() {
        collectionView.register(GalleryCollectionViewCell.self,
                                forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.prefetchDataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupNavigationBar() {
        setupTitle()
        setupBarButtonItem()
    }
    
    func setupTitle() {
        title = "Mobile Up Gallery"
    }
    
    func setupBarButtonItem() {
        
        let exitButtonItem = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(loginOrOutTapped))
        exitButtonItem.tintColor = Constants.Colors.titles
        navigationItem.rightBarButtonItem = exitButtonItem
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButtonItem.tintColor = Constants.Colors.titles
        navigationItem.backBarButtonItem = backButtonItem
    }
    
    @objc
    func loginOrOutTapped() {
        print("loginOrOutTapped")
    }
    
    func getPhotos() {
        photoService.fetchPhotos { [weak self] error in
            if let error = error {
                self?.present(UIAlertController.standard(error: error), animated: true, completion: nil)
            } else {
                self?.collectionView.reloadData()
            }
        }
    }
}
