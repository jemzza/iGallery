//
//  PhotoInteractor.swift
//  iGallery
//
//  Created by Alexander Litvinov on 07.08.2021.
//

import UIKit

protocol PhotoInteractor {
     var date: String { get }
     func downloadPhoto(completion: @escaping (UIImage?, Error?) -> Void)
     func cancelDownloading()
 }

class PhotoInteractorRealization: PhotoInteractor {
    
    //MARK: - Public Properties
    var date: String
    
    //MARK: - Private Properties
    private let url: URL
    private var imageDataTask: URLSessionDataTask?
    private static let cache = URLSession.shared.configuration.urlCache
    
    //MARK: - inits
    init(date: String, url: URL) {
        self.date = date
        self.url = url
    }
    
    //MARK: - Public Methods
    func downloadPhoto(completion: @escaping (UIImage?, Error?) -> Void) {
        
        if let cachedResponse = PhotoInteractorRealization.cache!.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            print("Find Item")
            completion(image, nil)
            return
        }
        
        imageDataTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, resonse, error in
            self?.imageDataTask = nil
            print("not Find Item")
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image, nil)
            }
        })
        
        imageDataTask?.resume()
    }
    
    func cancelDownloading() {
        imageDataTask?.cancel()
    }
    
    
}
