//
//  UserInfoRequest.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

struct UserInfoRequest: APIRequest {
    typealias Response = UserResponseDTO
    let method: HTTPMethod = .get
    let baseURL: URL? = URL(string: "https://api.github.com/")
    let path: String = "user"
    var parameters: [String : String] {
        return [:]
    }
    var headers: [String : String]? {
        [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "token \(KeychainManager.shard.load("Token") ?? "")"
        ]
    }    
}
