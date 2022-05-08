//
//  UserUseCase.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

final class UserUseCase {
    private let repository: UserRepository
    private let loginManager: LoginManager
    private var starredList: [RepositoryItem]

    var islogin: Bool {
        KeychainStorage.shard.load("Token") != nil
    }
    
    var profile: (name: String, imageURL: String) {
        return (repository.name ?? "", repository.profileImageURL ?? "")
    }
    
    init(
        repository: UserRepository = DefaultUserRepository(),
        loginManager: LoginManager = LoginManager(),
        starredList: [RepositoryItem] = []
    ) {
        self.repository = repository
        self.loginManager = loginManager
        self.starredList = starredList
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
    
    // 별표 아이콘을 탭했을 때 기존에 별표 표시한 레파지토리인지 확인하는 로직
    func toggleStarred(
        for item: RepositoryItem,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        if starredList.contains(item) {
            repository.unStar(name: item.login, title: item.name) { result in
                switch result {
                case .success(let isMarked):
                    if isMarked, let index = self.starredList.firstIndex(of: item) {
                        self.starredList.remove(at: index)
                    }
                    completion(.success(isMarked))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            repository.star(name: item.login, title: item.name) { result in
                switch result {
                case .success(let isMarked):
                    if isMarked {
                        self.starredList.append(item)
                    }
                    completion(.success(isMarked))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
