//
//  Extension+UIAlertController.swift
//  iGallery
//
//  Created by Alexander Litvinov on 05.08.2021.
//

import UIKit

extension UIAlertController {
    
    static func standard(error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "Error happened", message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { [weak alertController] _ in
            alertController?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        return alertController
    }
}
