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
    let user: Observable<User> = Observable(User(login: "", name: "", profileImageURL: "", repoURL: "", starredURL: ""))
    let isLoading: Observable<Bool> = Observable(false)
    
    init(useCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
        LoginManager.shared.addListener(self)
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
            isLoading.value = true
            user.value = useCase.user
            let repoURL = user.value?.repoURL ?? ""
            let path = user.value?.path(url: repoURL) ?? ""
            useCase.fetchRepositories(path: path) { result in
                switch result {
                case .success(let items):
                    self.items.value = items
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.isLoading.value = false
            }
        } else {
            user.value = User(login: "", name: "", profileImageURL: "", repoURL: "", starredURL: "")
            items.value = []
        }
    }
}
