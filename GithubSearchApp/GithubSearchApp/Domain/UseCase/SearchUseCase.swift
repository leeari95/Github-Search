//
//  SearchUseCase.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

final class SearchUseCase {
    private let searchRepository: SearchRepositories
    private var perPage: UInt = 30
    private var totalCount: UInt = 30
    private var currentPage: UInt = 1
    
    var canLoadMore: Bool {
        totalCount > perPage * currentPage
    }
    
    init(searchRepository: SearchRepositories = DefaultSearchRepositories()) {
        self.searchRepository = searchRepository
    }
    
    func fetchSearchRepositories(keyword: String, page: UInt, completion: @escaping (Result<[RepositoryItem], Error>) -> Void) {
        searchRepository.fetch(keyword: keyword, page: page, perPage: perPage) { result in
            switch result {
            case .success(let searchResult):
                if searchResult.totalCount > self.totalCount {
                    self.totalCount = UInt(searchResult.totalCount)
                }
                self.currentPage = page
                completion(.success(searchResult.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
