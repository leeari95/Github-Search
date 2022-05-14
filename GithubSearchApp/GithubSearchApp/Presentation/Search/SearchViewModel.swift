//
//  SearchViewModel.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/09.
//

import Foundation

protocol ProfileViewModelDelegate {
    func updatedItem(with item: RepositoryItem)
}

final class SearchViewModel {
    
    private let seachUseCase: SearchUseCase
    private let userUseCase: UserUseCase
    private var currentPage: UInt = 1
    private var lastKeyword: String = ""
    var delegate: ProfileViewModelDelegate?
    
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
    
    func starred(_ item: RepositoryItem) {
        userUseCase.toggleStarred(for: item) { newItem, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let newItem = newItem else {
                return
            }
            if let index = self.items.value?.map({ $0.id }).firstIndex(of: item.id) {
                self.items.value?[index] = newItem
            }
            if item.login == self.userUseCase.user?.login {
                self.delegate?.updatedItem(with: newItem)
            }
        }
    }
    

}
// MARK: - Login event handler
extension SearchViewModel: AuthChangeListener {
    func instanceName() -> String {
        String(describing: SearchViewModel.self)
    }
    
    func authStateDidChange(isLogged: Bool) {
        guard items.value?.isEmpty == false else {
            return
        }
        if isLogged {
            items.value = userUseCase.checkedStarred(for: items.value ?? [])
        } else if isLogged {
            items.value = items.value?.compactMap { item in
                var item = item
                item.changedMarkState(for: false)
                return item
            }
        }
    }

}
