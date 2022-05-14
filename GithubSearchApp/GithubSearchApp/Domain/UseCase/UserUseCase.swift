//
//  UserUseCase.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

final class UserUseCase {
    private let repository: UserRepository
    private var starredList: [Int] {
        didSet {
            guard KeychainStorage.shard.load("Token") != nil else {
                return
            }
            LoginManager.shared.executeNextWork(String(describing: SearchViewModel.self))
            LoginManager.shared.executeNextWork(String(describing: ProfileViewModel.self))
        }
    }

    var islogin: Bool {
        KeychainStorage.shard.load("Token") != nil
    }
    
    var user: User? {
        return repository.userInfo
    }
    
    init(
        repository: UserRepository = DefaultUserRepository(),
        starredList: [Int] = []
    ) {
        self.repository = repository
        self.starredList = starredList
        LoginManager.shared.addListener(self)
    }
    
    func fetchRepositories(path: String, completion: @escaping (Result<[RepositoryItem], Error>) -> Void) {
        repository.fetchRepositories(path: path) { result in
            switch result {
            case .success(let items):
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleStarred(
        for item: RepositoryItem,
        completion: @escaping (RepositoryItem?, Error?) -> Void
    ) {
        var item = item
        if let index = self.starredList.firstIndex(of: item.id) {
            repository.unStar(name: item.login, title: item.name) { result in
                switch result {
                case .success:
                    self.starredList.remove(at: index)
                    item.toggleStarred()
                    completion(item, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        } else {
            repository.star(name: item.login, title: item.name) { result in
                switch result {
                case .success:
                    self.starredList.append(item.id)
                    item.toggleStarred()
                    completion(item, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func checkedStarred(for items: [RepositoryItem]) -> [RepositoryItem] {
        guard LoginManager.shared.isLogged else {
            return items
        }
        var items = items
        items = items.map { item in
            var item = item
            if self.starredList.contains(item.id) {
                item.changedMarkState(for: true)
            }
            return item
        }
        return items
    }
}

// MARK: - Login event handler
extension UserUseCase: AuthChangeListener {
    func instanceName() -> String {
        String(describing: UserUseCase.self)
    }
    
    func authStateDidChange(isLogged: Bool) {
        if isLogged {
            self.fetchUserStarredList()
        } else {
            starredList = []
        }
    }
    
    private func fetchUserStarredList() {
        repository.fetchStarredList { result in
            switch result {
            case .success(let items):
                self.starredList = items.map { $0.id }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
