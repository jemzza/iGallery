//
//  Photo.swift
//  iGallery
//
//  Created by Alexander Litvinov on 07.08.2021.
//

import Foundation

struct Photo: Codable {
    //MARK: - Public Properties
    let id: Int
    let date: Double
    
    var src: String {
        return photo_1280
    }
    
    //MARK: - Private Properties
    let photo_1280: String
}
