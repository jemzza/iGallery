//
//  GalleryViewLayout.swift
//  iGallery
//
//  Created by Alexander Litvinov on 03.08.2021.
//

import UIKit

class GalleryViewLayout: UICollectionViewLayout {
    
    //MARK: - Public Properties
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    //MARK: - Private Properties
    private var contentBounds = CGRect.zero
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    
    //MARK: - Public Methods
    override func prepare() {
        super.prepare()
        print("Update")
        guard let collectionView = collectionView, collectionView.numberOfSections == 1 else {
            return assert(false, "GalleryViewLayout needs one section in collectionView")
        }
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        let count = collectionView.numberOfItems(inSection: 0)
        
        guard count > 0 else { return }
        
        let collectionViewWidth = collectionView.bounds.size.width
        let columnWidth = ceil(collectionViewWidth / CGFloat(Constants.numberOfColumns))
        
        var xOffsets = [CGFloat]()
        for column in 0..<Constants.numberOfColumns { xOffsets.append(CGFloat(column) * columnWidth) }
        
        var column = 0
        var yOffsets = [CGFloat](repeating: 0.0, count: Constants.numberOfColumns)
        
        
        let photoHeight: CGFloat = {
            return ceil(columnWidth * Constants.squareRatio)
        }()
        
        let addAttributes: (Int, CGFloat, Int) -> Void = { item, height, column in
            let insets = UIEdgeInsets(
                top: item < Constants.numberOfColumns ? 0 : Constants.cellPadding,
                left: column == 0 ? 0 : Constants.cellPadding,
                bottom: Constants.cellPadding,
                right: column == Constants.numberOfColumns - 1 ? 0 : Constants.cellPadding
            )
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
            let insetFrame = frame.inset(by: insets)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            attributes.frame = insetFrame
            self.cachedAttributes.append(attributes)
            
            self.contentBounds.size.height = max(self.contentBounds.height, frame.maxY)
            yOffsets[column] = yOffsets[column] + height
        }
        
        for item in 0..<count {
            let nextColumn = column < (Constants.numberOfColumns - 1) ? (column + 1) : 0
            let height: CGFloat
            
            height = photoHeight + 2 * Constants.cellPadding
            addAttributes(item, height, column)
            
            if yOffsets[nextColumn] < yOffsets[column] { column = nextColumn }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item < cachedAttributes.count else {
            assert(false, "Index exceeds array bounds")
        }
        return cachedAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { $0.frame.intersects(rect) }
    }
    
}

private extension GalleryViewLayout {
    struct Constants {
        static let numberOfColumns: Int = 2
        static let cellPadding: CGFloat = 1.0
        static let portraitRatio: CGFloat = 4 / 3
        static let albumRatio: CGFloat = 3 / 4
        static let squareRatio: CGFloat = 1.0
    }
}
