//
//  DefaultSearchStorage.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

final class DefaultSearchStorage: SearchStorage {
    private let apiProvier: APIProvider
    
    init(apiProvier: APIProvider = DefaultAPIProvider()) {
        self.apiProvier = apiProvier
    }
    
    func getSearchRepositories(
        for requestDTO: RepoSearchRequest,
        completion: @escaping (Result<RepoSearchResponseDTO, Error>) -> Void
    ) {
        apiProvier.request(requestDTO) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
