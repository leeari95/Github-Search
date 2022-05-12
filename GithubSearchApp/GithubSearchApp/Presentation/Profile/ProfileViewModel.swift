//
//  ProfileViewModel.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/12.
//

import Foundation

final class ProfileViewModel {
    private let useCase: UserUseCase
    
    // MARK: - OutPut
    let items: Observable<[RepositoryItem]> = Observable([])
    
    init(useCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
        LoginManager.shared.addListener(self)
        items.value = [
            RepositoryItem(id: 123, name: "Ari", login: "leeari95", description: "Repository description", isMarkStar: true, starredCount: 0)
        ]
    }
    
    // MARK: - Input
    func didTapLoginButton() {
        LoginManager.shared.authorize()
    }
    
    func didTapLogoutButton() {
        LoginManager.shared.logout()
    }
}

// MARK: - Login event handler
extension ProfileViewModel: AuthChangeListener {
    func instanceName() -> String {
        return String(describing: ProfileViewModel.self)
    }
    func authStateDidChange(isLogged: Bool) {
        if isLogged {
            
        } else {
            
        }
    }
}
