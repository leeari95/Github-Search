//
//  AppCoordinator.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/10.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var rootViewController: UITabBarController!
    
    init(rootViewController: UITabBarController = UITabBarController()) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let searchItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let profileItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        let searchCoordinator = SearchCoordinator()
        searchCoordinator.parentCoordinator = self
        searchCoordinator.start()
        let searchViewController = searchCoordinator.starPush()
        searchViewController.tabBarItem = searchItem
        
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.parentCoordinator = self
        profileCoordinator.start()
        let profileViewController = profileCoordinator.starPush()
        profileViewController.tabBarItem = profileItem
        
        rootViewController.viewControllers = [searchViewController, profileViewController]
    }
    
    func setTabBaController() -> UITabBarController {
        return rootViewController
    }
}
