//
//  UserRepository.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

protocol UserRepository {
    var name: String? { get }
    
    var profileImageURL: String? { get }
    
    func fetchRepositories(
        path: String,
        completion: @escaping (Result<[RepositoryItem], Error>) -> Void
    )
    
    func fetchStarredList(
        completion: @escaping (Result<[RepositoryItem], Error>) -> Void
    )
    
    func star(completion: @escaping (Result<Bool, Error>) -> Void)
    
    func unStar(completion: @escaping (Result<Bool, Error>) -> Void)
}
