//
//  RepositoryItem.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

struct RepositoryItem {
    let id: Int
    let name: String
    let login: String
    let description: String
    private(set) var isMarkStar: Bool
    private(set) var starredCount: Int
    
    init(
        id: Int,
        name: String,
        login: String,
        description: String,
        isMarkStar: Bool,
        starredCount: Int
    ) {
        self.id = id
        self.name = name
        self.login = login
        self.description = description
        self.isMarkStar = isMarkStar
        self.starredCount = starredCount
    }
    
    mutating func toggleStarred() {
        isMarkStar = isMarkStar ? false : true
        if isMarkStar {
            starredCount += 1
        } else {
            starredCount -= 1
        }
    }
}
