//
//  ProfileViewController.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/08.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        let loginButton = UIBarButtonItem(title: "Login", style: .plain, target: nil, action: nil)
        if #available(iOS 13.0, *) {
            loginButton.tintColor = .label
        } else {
            loginButton.tintColor = .white
        }
        navigationItem.rightBarButtonItem = loginButton
        
    }
}
