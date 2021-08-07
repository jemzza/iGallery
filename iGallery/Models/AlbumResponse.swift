//
//  AlbumResponse.swift
//  iGallery
//
//  Created by Alexander Litvinov on 07.08.2021.
//

import Foundation

struct AlbumResponseWrapped: Codable {
    //MARK: - Public Properties
    let response: AlbumResponse
}

struct AlbumResponse: Codable {
    //MARK: - Public Properties
    let count: Int
    let items: [Photo]
}
