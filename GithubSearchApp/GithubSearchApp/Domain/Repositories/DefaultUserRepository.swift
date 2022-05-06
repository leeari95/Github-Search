//
//  DefaultUserRepository.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/06.
//

import Foundation

final class DefaultUserRepository: UserRepository {
    private var user: User?
    private let storage: UserStorage
    
    var name: String? {
        user?.name
    }
    
    var profileImageURL: String? {
        user?.profileImageURL
    }
    
    init(storage: UserStorage = DefaultUserStorage()) {
        self.storage = storage
        self.user = storage.info?.toDomain()
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
    
    func star(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = user?.starredURL, let path = user?.path(url: url) else {
            return
        }
        storage.putStarred(path: path) { result in
            switch result {
            case .success(let isMarked):
                completion(.success(isMarked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func unStar(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = user?.starredURL, let path = user?.path(url: url) else {
            return
        }
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
