//
//  ViewCellProtocol.swift
//  iGallery
//
//  Created by Alexander Litvinov on 05.08.2021.
//

import Foundation
import UIKit

protocol ViewCellProtocol: UICollectionViewCell {
    
    var delegate: PhotoCellDelegate? { get set }
    static var reuseIdentifier: String { get }
    func configure(with image: UIImage)
    
}
