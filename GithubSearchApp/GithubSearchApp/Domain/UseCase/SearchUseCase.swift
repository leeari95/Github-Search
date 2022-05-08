//
//  SearchUseCase.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

final class SearchUseCase {
    private let searchRepository: SearchRepositories
    private var currentPerPage: UInt = 20
    private var totalCount: UInt = 20
    
    var canSearch: Bool {
        totalCount - currentPerPage > 0
    }
    
    init(searchRepository: SearchRepositories = DefaultSearchRepositories()) {
        self.searchRepository = searchRepository
    }
    
    func fetchSearchRepositories(keyword: String, completion: @escaping (Result<[RepositoryItem], Error>) -> Void) {
        searchRepository.fetch(keyword: keyword, page: 1, perPage: currentPerPage) { result in
            switch result {
            case .success(let searchResult):
                if searchResult.totalCount > self.totalCount {
                    self.currentPerPage += 20
                    self.totalCount = self.currentPerPage
                }
                completion(.success(searchResult.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
