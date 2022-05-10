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
        }
    }

    var islogin: Bool {
        KeychainStorage.shard.load("Token") != nil
    }
    
    var profile: (name: String, imageURL: String) {
        return (repository.name ?? "", repository.profileImageURL ?? "")
    }
    
    var userStarredList: [Int] {
        return starredList
    }
    
    init(
        repository: UserRepository = DefaultUserRepository(),
        starredList: [Int] = []
    ) {
        self.repository = repository
        self.starredList = starredList
        LoginManager.shared.addListener(self)
    }
    
    func setUp() {
        if islogin {
            repository.fetchStarredList { result in
                switch result {
                case .success(let items):
                    self.starredList = items
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            starredList = []
        }
    }
    
    func fetchRepositories(completion: @escaping (Result<[RepositoryItem], Error>) -> Void) {
        repository.fetchStarredList { result in
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
        completion: @escaping (Error?) -> Void
    ) {
        if starredList.contains(item.id) {
            repository.unStar(name: item.login, title: item.name) { result in
                switch result {
                case .success:
                    guard let index = self.starredList.firstIndex(of: item.id) else {
                        return
                    }
                    self.starredList.remove(at: index)
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        } else {
            repository.star(name: item.login, title: item.name) { result in
                switch result {
                case .success:
                    self.starredList.append(item.id)
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
}

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
