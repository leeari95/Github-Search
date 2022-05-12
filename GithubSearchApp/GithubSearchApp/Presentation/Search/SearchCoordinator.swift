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
    private var topViewController: SearchViewController?
    
    init(rootViewController: UINavigationController = .init()) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let searchViewController = SearchViewController()
        topViewController = searchViewController
        rootViewController.setViewControllers([searchViewController], animated: false)
    }
    
    func starPush(viewModel: SearchViewModel) -> UINavigationController {
        topViewController?.viewModel = viewModel
        return rootViewController
    }
}
