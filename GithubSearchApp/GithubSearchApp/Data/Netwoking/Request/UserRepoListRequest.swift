//
//  UserRepoListRequest.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

struct UserRepoListRequest: APIRequest {
    typealias Response = ItemResponseDTO
    let method: HTTPMethod = .get
    let baseURL: URL? = URL(string: "https://api.github.com/users/")
    let path: String
    let parameters: [String : String] = [:]
    var headers: [String : String]? {
        return [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "token \(Secrets.developerToken)"
        ]
    }
    
    init(path: String) {
        self.path = path
    }
}
