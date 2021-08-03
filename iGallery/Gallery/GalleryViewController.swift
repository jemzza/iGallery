//
//  ViewController.swift
//  iGallery
//
//  Created by Alexander Litvinov on 03.08.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    
    //MARK: - Public Methods
    let reuseIdentifier = "Cell"
    
    override func loadView() {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: GalleryViewLayout())
        
        collectionView.register(GalleryCollectionViewCell.self,
                                forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier)
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.alwaysBounceVertical = true
        collectionView.prefetchDataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(GalleryCollectionViewCell.reuseIdentifier)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Mobile Up Gallery"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход/Вход", style: .plain, target: self, action: #selector(loginOrOutTapped))
//        navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.titles
    
    }
    
    @objc
    private func loginOrOutTapped() {
        print("loginOrOutTapped")
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
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier, for: indexPath) as? GalleryCollectionViewCell else {
            assert(false, "Cell for gallery view must be of type GallleryViewCell")
            return UICollectionViewCell()
        }
        cell.configure(for: UIImage(named: indexPath.item % 2 == 0 ? "ref011" : "ref012")!)
        return cell
    }
}
