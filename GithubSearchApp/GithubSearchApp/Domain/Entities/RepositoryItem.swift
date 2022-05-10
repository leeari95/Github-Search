//
//  RepositoryItem.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

struct RepositoryItem: Equatable, Hashable {
    let id: Int
    let name: String
    let login: String
    let description: String
    private(set) var isMarkedStar: Bool
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
        self.isMarkedStar = isMarkStar
        self.starredCount = starredCount
    }

    mutating func changedMarkState(for state: Bool) {
       isMarkedStar = state
        
    }
    
    mutating func toggleStarred() {
        isMarkedStar.toggle()
        if isMarkedStar {
            starredCount += 1
        } else {
            starredCount -= 1
        }
    }
}
