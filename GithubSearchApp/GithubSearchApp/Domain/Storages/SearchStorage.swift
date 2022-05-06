//
//  SearchStorage.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

protocol SearchStorage {
    func getSearchRepositories(
        for requestDTO: RepoSearchRequest,
        completion: @escaping (Result<RepoSearchResponseDTO, Error>) -> Void
    )
}
