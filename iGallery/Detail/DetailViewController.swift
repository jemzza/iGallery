//
//  DetailViewController.swift
//  iGallery
//
//  Created by Alexander Litvinov on 04.08.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Public Properties
    override var prefersStatusBarHidden: Bool {
        return navigationBarHidden
    }
    
    // MARK: - Private Properties
    
    private var navigationBarHidden = false
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
    }
    
    // MARK: - Private Methods
    private func setupNavigationBar() {
        title = "5 ноября 2019"
        setupBarButtonItems()
        
    }
    
    private func setupBarButtonItems() {
        setupBackButton()
        setupShareButton()
    }
    
    private func setupBackButton() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        let backImage = UIImage(named: "backButton")
        backButton.setImage(backImage, for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: -70.0, bottom: 10.0, right: 0.0)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.setTitle("", for: .normal)
        backButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItems = [backBarButton]
    }
    
    private func setupShareButton() {
        
    }
    
    @objc
    private func buttonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailViewCell.reuseIdentifier, for: indexPath) as? DetailViewCell else {
            assert(false, "Cell for gallery view must be of type PhotoViewCell")
            return UICollectionViewCell()
        }
        cell.configure(with: UIImage(imageLiteralResourceName: indexPath.item % 2 == 0 ? "ref011" : "ref012"))
        cell.delegate = self
        
        return cell
    }
}

// MARK: - DetailViewController
extension DetailViewController: DetailViewCellDelegate {
    
    func photoViewCellDidTap(_ cell: DetailViewCell) {
        print("User tapped!")
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.height,
                      height: collectionView.bounds.height)
    }
}

private extension DetailViewController {
    
    // MARK: - Private Nested
    
    struct Static {
        static let spacing: CGFloat = 2.0
    }
    
    // MARK: - Private Methods
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Static.spacing
        layout.sectionInset = UIEdgeInsets(
            top: 0.0,
            left: Static.spacing / 2,
            bottom: 0.0,
            right: Static.spacing / 2
        )
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        
        collectionView.register(
            DetailViewCell.self,
            forCellWithReuseIdentifier: DetailViewCell.reuseIdentifier
        )
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -Static.spacing / 2),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Static.spacing / 2),
        ])
    }
    
    func toggleNavigationBar() {
        navigationBarHidden.toggle()
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(navigationBarHidden, animated: false)
    }
    
}
