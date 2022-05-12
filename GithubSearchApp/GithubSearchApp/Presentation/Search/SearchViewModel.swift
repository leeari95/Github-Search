//
//  SearchViewModel.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/09.
//

import Foundation

final class SearchViewModel {
    
    private let seachUseCase: SearchUseCase
    private let userUseCase: UserUseCase
    private var currentPage: UInt = 1
    private var lastKeyword: String = ""
    
    // MARK: - Output
    let items: Observable<[RepositoryItem]> = Observable([])
    let errorMesaage: Observable<Message> = Observable(Message(title: "", description: ""))
    let isLoading: Observable<Bool> = Observable(false)
    
    init(seachUseCase: SearchUseCase = SearchUseCase(), userUseCase: UserUseCase = UserUseCase()) {
        self.seachUseCase = seachUseCase
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
    
    func didSearch(keyword: String) {
        if lastKeyword != keyword {
            items.value = []
            currentPage = 1
        }
        self.isLoading.value = true
        
        seachUseCase.fetchSearchRepositories(keyword: keyword, page: currentPage) { result in
            switch result {
            case .success(let items):
                let filteredItems = self.userUseCase.checkedStarred(for: items)
                self.items.value?.append(contentsOf: filteredItems)
                self.currentPage += 1
                self.isLoading.value = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        lastKeyword = keyword
    }
    
    func didScroll() {
        if seachUseCase.canLoadMore {
            didSearch(keyword: lastKeyword)
        }
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
