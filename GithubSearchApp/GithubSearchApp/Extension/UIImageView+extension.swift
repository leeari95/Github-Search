//
//  UIImageView+extension.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/06.
//

import UIKit

extension UIImageView {
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        self.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        let centerY = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }
    
    func load(url: String, placeholder: UIImage?, cache: URLCache? = nil) {
        let activityIndicator = self.activityIndicator
        if let cachedImage = DefaultCacheStorage.shared.load(for: url) {
            self.image = cachedImage
        } else {
            activityIndicator.startAnimating()
            DefaultCacheStorage.shared.downloadImage(with: url) { result in
                switch result {
                case .success(let image):
                    DefaultCacheStorage.shared.setImage(of: image, for: url)
                    DispatchQueue.main.async {
                        self.image = image
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    }
                case .failure(let error):
                    print("Failed to load image.\nerror: \(error)")
                    activityIndicator.stopAnimating()
                }
            }
        }
    }
}
