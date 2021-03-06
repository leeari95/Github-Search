//
//  RepoSearchRequest.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

struct RepoSearchRequest: APIRequest {
    typealias Response = RepoSearchResponseDTO
    let method: HTTPMethod = .get
    let baseURL: URL? = URL(string: "https://api.github.com/")
    let path: String = "search/repositories"
    let headers: [String : String]? = ["Accept": "application/vnd.github.v3+json"]
    private var keyword: String
    private var perPage: UInt
    let page: UInt
    
    var parameters: [String : String] {
        [
            "q": keyword,
            "per_page": perPage.description,
            "page": page.description
        ]
    }
    
    init(keyword: String, page: UInt, perPage: UInt) {
        self.keyword = keyword
        self.page = page
        self.perPage = perPage
    }
    
    mutating func editSearchWord(to searchWord: String) {
        keyword = searchWord
    }
    
    mutating func nextPage() {
        perPage += 20
    }
}



