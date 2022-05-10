//
//  SearchCoordinator.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/10.
//

import UIKit

final class SearchCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController = .init()) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController()
        searchViewController.viewModel = viewModel
        rootViewController.setViewControllers([searchViewController], animated: false)
    }
    
    func starPush() -> UINavigationController {
        return rootViewController
    }
}
