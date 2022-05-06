//
//  SearchRepository.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

protocol SearchRepositories {
    func fetch(
        keyword: String,
        page: UInt,
        perPage: UInt,
        completion: @escaping (Result<SearchRepo, Error>) -> Void
    )
}
