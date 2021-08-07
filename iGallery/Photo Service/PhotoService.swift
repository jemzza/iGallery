//
//  PhotoServiceRealization.swift
//  iGallery
//
//  Created by Alexander Litvinov on 06.08.2021.
//

import Foundation

protocol PhotoService {
     var count: Int { get }
     func photoInteractor(forPhotoWithIndex: Int) -> PhotoInteractor?
     func fetchPhotos(completion: @escaping (Error?) -> Void)
 }

class PhotoServiceRealization: PhotoService {
    
    //MARK: - Public Properties
    var count: Int {
        return photos.count
    }
    //MARK: - Private Properties
    private var photos: [Photo] = []
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM 'в' HH:mm"
        return dateFormatter
    }()

    //MARK: - Public Methods
    func photoInteractor(forPhotoWithIndex index: Int) -> PhotoInteractor? {
        guard index >= 0 && index < photos.count,
              let url = URL(string: photos[index].src) else { return nil }
        return PhotoInteractorRealization(date: getDate(for: photos[index].date), url: url)
    }
    
    func fetchPhotos(completion: @escaping (Error?) -> Void) {
        requestPhotos { [weak self] photos in
            self?.photos = photos
            completion(nil)
        } failure: { error in
            completion(error)
        }
    }
}

//https://api.vk.com/method/photos.get?owner_id=-128666765&album_id=266276915&access_token=a4998974a4998974a499897403a4e98509aa499a4998974fac4e4bfa614dc87001f99c5&count=20&v=5.76

private extension PhotoServiceRealization {
    
    //MARK: - Private Nested
    struct Configuration {
        static let baseUrl = "https://api.vk.com/method/photos.get"
    }
    
    //MARK: - Private Methods
    func requestPhotos(success: @escaping ([Photo]) -> Void,
                       failure: @escaping (Error) -> Void) {
        
        guard var urlComponents = URLComponents(string: Configuration.baseUrl) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: "-128666765"),
            URLQueryItem(name: "album_id", value: "266276915"),
            URLQueryItem(name: "access_token", value: "a4998974a4998974a499897403a4e98509aa499a4998974fac4e4bfa614dc87001f99c5"),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "v", value: "5.76")
        ]
        
        guard let url = urlComponents.url else { return }
        print(url)
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            do {
                let object =  try JSONDecoder().decode(AlbumResponseWrapped.self, from: data)
                print(object)
                DispatchQueue.main.async {
                    success(object.response.items)
                }
            } catch {
                DispatchQueue.main.async {
                    failure(error)
                    print(error.localizedDescription + " Error in parsing")
                }
            }
        }
        
        task.resume()
    }
    
    func getDate(for date: Double) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: date))
    }
}
