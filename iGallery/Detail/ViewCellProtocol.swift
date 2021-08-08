//
//  ViewCellProtocol.swift
//  iGallery
//
//  Created by Alexander Litvinov on 05.08.2021.
//

import Foundation
import UIKit

protocol ViewCellProtocol: UICollectionViewCell {
    
    static var reuseIdentifier: String { get }
    var delegate: PhotoCellDelegate? { get set }
    func configure(with interactor: PhotoInteractor)
}
