//
//  UIViewController+extension.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/09.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

