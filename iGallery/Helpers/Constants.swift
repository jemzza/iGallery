//
//  Constants.swift
//  iGallery
//
//  Created by Alexander Litvinov on 04.08.2021.
//

import UIKit

struct Constants {
    
    struct Colors {
        static let titles = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
        static let buttonTitle = UIColor.white
    }
    
    struct Font {
        
        struct Weight {
            static let f700: UIFont.Weight = .bold
            static let f600: UIFont.Weight = .medium
            static let f500: UIFont.Weight = .regular
        }
        
        struct Size {
            static let largeAuth: CGFloat = 48
            static let small: CGFloat = 18
        }
    }
}
