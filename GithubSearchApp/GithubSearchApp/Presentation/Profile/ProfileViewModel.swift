//
//  ProfileViewModel.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/10.
//

import Foundation

final class ProfileViewModel {
    private let useCase: UserUseCase
    
    // MARK: - OutPut
    
    init(useCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
        LoginManager.shared.addListener(self)
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
