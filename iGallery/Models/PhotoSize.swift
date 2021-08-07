//
//  PhotoSize.swift
//  iGallery
//
//  Created by Alexander Litvinov on 07.08.2021.
//

import Foundation

struct PhotoSize: Codable {
    //MARK: - Public Properties
    let type: String
    let url: String
    let width: Int
    let height: Int
}
