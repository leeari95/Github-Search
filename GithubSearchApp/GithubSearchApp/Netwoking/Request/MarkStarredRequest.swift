//
//  MarkStarredRequest.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

struct MarkStarredRequest {
    let method: HTTPMethod
    let baseURL: URL? = URL(string: "https://api.github.com/user/starred/")
    let path: String
    var headers: [String : String]? {
        return [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "token \(KeychainManager.shard.load("Token") ?? "")"
        ]
    }
    
    init(path: String, method: HTTPMethod) {
        self.path = path
        self.method = method
    }
}

extension MarkStarredRequest {
    var urlReqeust: URLRequest? {
        guard let url = self.baseURL?.appendingPathComponent(self.path)else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        if let headers = self.headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}
