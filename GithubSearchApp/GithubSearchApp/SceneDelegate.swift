//
//  SceneDelegate.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let code = URLContexts.first?.url.absoluteString.components(separatedBy: "code=").last
        code.flatMap {
            LoginManager.shared.requestToken(code: $0) { result in
                switch result {
                case .success(let isLogin):
                    DispatchQueue.main.async {
                        let mainViewController = (self.window?.rootViewController as? UITabBarController)
                            .flatMap { $0.selectedViewController as? UINavigationController }
                            .flatMap { $0.topViewController as? SearchViewController }
                        let profileViewCotroller = (self.window?.rootViewController as? UITabBarController)
                            .flatMap { $0.viewControllers?[1] as? UINavigationController }
                            .flatMap { $0.topViewController as? ProfileViewController }

                        if isLogin {
                            mainViewController?.navigationItem.rightBarButtonItem?.title = "Logout"
                            profileViewCotroller?.navigationItem.rightBarButtonItem?.title = "Logout"
                        } else {
                            mainViewController?.showAlert(title: "Notice", message: "Login failed.", completion: nil)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windoewScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: windoewScene)
        appCoordinator = AppCoordinator()
        appCoordinator?.start()
        window?.rootViewController = appCoordinator?.setTabBaController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

