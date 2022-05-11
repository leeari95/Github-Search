//
//  RepositoryItem.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

struct RepositoryItem: Equatable {
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

extension RepositoryItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(login)
        hasher.combine(description)
    }
    static func ==(lhs: RepositoryItem, rhs: RepositoryItem) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.login == rhs.description
     }
}
