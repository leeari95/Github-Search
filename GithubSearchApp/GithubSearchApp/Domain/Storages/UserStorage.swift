//
//  UserStorage.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/06.
//

import Foundation

protocol UserStorage {
    var info: UserResponseDTO? { get }
    
    func getInfoResponse(
        for requestDTO: UserInfoRequest,
        completion: @escaping (Result<UserResponseDTO, Error>) -> Void
    )
    
    func getRepositories(
        for requestDTO: UserRepoListRequest,
        completion: @escaping (Result<[ItemResponseDTO], Error>) -> Void
    )
    
    func putStarred(path: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func deleteStarred(path: String, completion: @escaping (Result<Bool, Error>) -> Void)
}
