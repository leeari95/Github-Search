//
//  DefaultCacheStorage.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/06.
//

import UIKit

class DefaultCacheStorage {
    private let cache = NSCache<NSString, UIImage>()
    static let shared = DefaultCacheStorage()
    
    private init() {}
    
    func load(for key: String) -> UIImage? {
        let itemURL = NSString(string: key)
        return cache.object(forKey: itemURL)
    }
    
    func setImage(of image: UIImage, for key: String) {
        let itemURL = NSString(string: key)
        cache.setObject(image, forKey: itemURL)
    }
    
    func downloadImage(
        with url: String,
        completion: @escaping (UIImage) -> Void
    ) {
        let apiProvider = DefaultAPIProvider()
        
        guard let imageURL = URL(string: url) else {
            return
        }
        let imageRequest = URLRequest(url: imageURL)
        
        apiProvider.execute(request: imageRequest) { result in
            switch result {
            case .success(let data):
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
