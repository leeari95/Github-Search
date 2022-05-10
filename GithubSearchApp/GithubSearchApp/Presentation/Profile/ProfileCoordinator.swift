//
//  ProfileCoordinator.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/10.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController = UINavigationController()) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewModel = SearchViewModel()
        let profileViewController = ProfileViewController()
        profileViewController.viewModel = viewModel
        rootViewController.setViewControllers([profileViewController], animated: false)
    }
    
    func starPush() -> UINavigationController {
        return rootViewController
    }
}
