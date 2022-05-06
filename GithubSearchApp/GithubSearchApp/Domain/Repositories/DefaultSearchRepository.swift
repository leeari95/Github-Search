//
//  DefaultSearchRepository.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/06.
//

import Foundation

final class DefaultSearchRepositories: SearchRepositories {
    private let storage: SearchStorage
    
    init(storage: SearchStorage = DefaultSearchStorage()) {
        self.storage = storage
    }
    
    func fetch(
        keyword: String,
        page: UInt = 1,
        perPage: UInt,
        completion: @escaping (Result<SearchRepo, Error>) -> Void
    ) {
        let request = RepoSearchRequest(keyword: keyword, page: page, perPage: perPage)
        storage.getSearchRepositories(for: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
