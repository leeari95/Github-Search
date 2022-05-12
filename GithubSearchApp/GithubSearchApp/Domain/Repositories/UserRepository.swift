//
//  UserRepository.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/07.
//

import Foundation

protocol UserRepository {
    var userInfo: User? { get }
    
    func fetchRepositories(
        path: String,
        completion: @escaping (Result<[RepositoryItem], Error>) -> Void
    )
    
    func fetchStarredList(
        completion: @escaping (Result<[RepositoryItem], Error>) -> Void
    )
    
    func star(name: String, title: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func unStar(name: String, title: String, completion: @escaping (Result<Bool, Error>) -> Void)
}
