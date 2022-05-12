//
//  DefaultUserRepository.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/06.
//

import Foundation

final class DefaultUserRepository: UserRepository {
    private var user: User? {
        didSet {
            guard KeychainStorage.shard.load("Token") != nil else {
                return
            }
            LoginManager.shared.executeNextWork(String(describing: UserUseCase.self))
        }
    }
    private let storage: UserStorage
    
    var userInfo: User? {
        return user
    }
    
    init(storage: UserStorage = DefaultUserStorage()) {
        self.storage = storage
        LoginManager.shared.addListener(self)
    }
    
    func fetchRepositories(
        path: String = "",
        completion: @escaping (Result<[RepositoryItem], Error>) -> Void
    ) {
        let request = UserRepoListRequest(path: path)
        storage.getRepositories(for: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.map { $0.toDomain() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchStarredList(
        completion: @escaping (Result<[RepositoryItem], Error>) -> Void
    ) {
        guard let url = user?.starredURL, let path = user?.path(url: url) else {
            return completion(.failure(UserRepositoryError.invalidPath))
        }
        fetchRepositories(path: path) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func star(name: String, title: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let path = "\(name)/\(title)"
        storage.putStarred(path: path) { result in
            switch result {
            case .success(let isMarked):
                completion(.success(isMarked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func unStar(name: String, title: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let path = "\(name)/\(title)"
        storage.deleteStarred(path: path) { result in
            switch result {
            case .success(let isMarked):
                completion(.success(isMarked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum UserRepositoryError: LocalizedError {
    case invalidPath
    
    var errorDescription: String? {
        switch self {
        case .invalidPath:
            return "유효하지 않는 path입니다. 다시 확인해주세요."
        }
    }
}

extension DefaultUserRepository: AuthChangeListener {
    func instanceName() -> String {
        String(describing: DefaultUserRepository.self)
    }
    
    func authStateDidChange(isLogged: Bool) {
        if isLogged {
            self.user = self.storage.info?.toDomain()
        } else {
            user = nil
        }
    }
}
