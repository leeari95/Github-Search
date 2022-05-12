//
//  SearchViewModel.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/09.
//

import Foundation

final class SearchViewModel {
    
    private let useCase: SearchUseCase
    private let userUseCase: UserUseCase
    
    // MARK: - Output
    let items: Observable<[RepositoryItem]> = Observable([])
    let errorMesaage: Observable<Message> = Observable(Message(title: "", description: ""))
    let isLoading: Observable<Bool> = Observable(false)
    
    init(useCase: SearchUseCase = SearchUseCase(), userUseCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
        self.userUseCase = userUseCase
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
extension SearchViewModel: AuthChangeListener {
    func instanceName() -> String {
        String(describing: SearchViewModel.self)
    }
    
    func authStateDidChange(isLogged: Bool) {

    }

}
