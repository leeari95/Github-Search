//
//  APIAddress.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import Foundation

enum APIAddress {
    case code(clientID: String, scope: String)
    case token(clientID: String, clientSecret: String, code: String)
    case user
    case repoSearch(searchWord: String, perPage: UInt, page: UInt)
    case starredList
    case starred(owner: String, repo: String)
    
    var url: URL? {
        switch self {
        case .code(let clientID, let scope):
            var components = URLComponents(string: "https://github.com/login/oauth/authorize")
            components?.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "scope", value: scope),
            ]
            return components?.url
        case .token(let clientID, let clientSecret, let code):
            var components = URLComponents(string: "https://github.com/login/oauth/access_token")
            components?.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "client_secret", value: clientSecret),
                URLQueryItem(name: "code", value: code)
            ]
            return components?.url
        case .user:
            return URL(string: "https://api.github.com/user")
        case .repoSearch(let searchWord, let perPage, let page):
            var components = URLComponents(string: "https://api.github.com/search/repositories")
            components?.queryItems = [
                URLQueryItem(name: "q", value: searchWord),
                URLQueryItem(name: "per_page", value: perPage.description),
                URLQueryItem(name: "page", value: page.description),
            ]
            return components?.url
        case .starredList:
            return URL(string: "https://api.github.com/user/starred")
        case .starred(let owner, let repo):
            return URL(string: "https://api.github.com/user/starred/\(owner)/\(repo)")
        }
    }
}
